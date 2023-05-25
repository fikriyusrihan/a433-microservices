#! /bin/bash

docker build -t item-app:v1 .

docker images

docker tag item-app:v1 artworkspace/item-app:v1

echo "$PASSWORD_DOCKER_HUB" | docker login -u artworkspace --password-stdin

docker push artworkspace/item-app:v1