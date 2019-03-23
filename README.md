# Flask monitoring

This repo is a place for me to play around with using various
monitoring applications (prometheus, grafana, etc) for a very simple
flask app (hello world). 

Everything is running in its own Docker container communicating via
docker networks. Containers and networks are built and setup using
Terraform.

## Usage

You can get everything up and running by simply running
`./run.sh`. This will stop any containers running, remove existing
containers for this project then run `terraform plan` and `terraform
apply --auto-approve`. This is just a quick script for when you're
iterating on things. It is not something you would want to use in live
scenarios.

Four services are started in containers by terraform:

1. A flask app (`flask-app`) on ports 5000 and 8000
2. Prometheus (`prometheus`) on port 9090
3. Grafana (`grafana`) on port 3000
4. Alertmanager (`alertmanager`) on port 9093


The flask app servers it normal content over 5000 and 8000 if for
Prometheus. Port 8000 is not exposed outside of the docker network
(`prom`)
