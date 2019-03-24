#!/usr/bin/env bash

set -e

echo "Stopping running containers"
[ -z "$(docker ps -q)" ] || docker stop $(docker ps -q)
echo "Deleting existing contiainers"
[ -z "$(docker ps -q)" ] || docker rm -f $(docker ps -q)
echo "Deleting images specific to project"
images=$(docker images | grep flask-monitoring | awk '{ print $3 }')
if [ ! -z "$images" ]
then
    docker rmi -f $images
fi

terraform plan

if [[ $? -eq 0 ]]
then
    terraform apply --auto-approve
fi
