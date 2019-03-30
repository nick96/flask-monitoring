package flaskApp

import (
	"context"
	"log"

	"syscall"
	"time"

	"github.com/containerd/containerd"
	"github.com/containerd/containerd/cio"
	"github.com/containerd/containerd/namespaces"
	"github.com/containerd/containerd/oci"
)

const (
	namespace string = "flask-monitoring"
	baseImage string = "docker.io/library/python:3.7"
	containerName string = "flask-app"
)

func flaskApp() error {
	socketPath := "/run/containerd/containerd.sock"
	client, err := containerd.New(socketPath)
	if err != nil {
		return err
	}
	defer client.Close()

	ctx := namespaces.WithNamespace(context.Background(), namespace)
	log.Printf("Pulling image from %s", baseImage)
	img, err := client.Pull(ctx, baseImage, containerd.WithPullUnpack)
	if err != nil {
		return err
	}
	log.Printf("Successfully pulled %s image\n", img.Name())

	snapshotName := containerName + "-snapshot"
	container, err := client.NewContainer(
		ctx,
		containerName,
		containerd.WithNewSnapshot(snapshotName, img),
		containerd.WithNewSpec(oci.WithImageConfig(img)),
	)
	if err != nil {
		return err
	}
	defer container.Delete(ctx, containerd.WithSnapshotCleanup)
	log.Printf(
		"Successfully created container with ID %s and snapshot with ID '%s'",
		container.ID(),
		snapshotName,
	)

	task, err := container.NewTask(ctx, cio.NewCreator(cio.WithStdio))
	if err != nil {
		return err
	}

	exitStatusC, err := task.Wait(ctx)
	if err != nil {
		return err
	}
	if err := task.Start(ctx); err != nil {
		return err
	}

	time.Sleep(3 * time.Second)

	if err := task.Kill(ctx, syscall.SIGTERM); err != nil {
		return err
	}

	status := <-exitStatusC
	code, _, err := status.Result()
	if err != nil {
		return err
	}

	log.Printf("%s exited with status: %d\n", containerName, code)

	return nil
}
