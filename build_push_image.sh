#! /bin/bash

# Build item-app image using Dockerfile in current directory
# Tag the image with v1
docker build -t item-app:v1 .

# Show all local images to confirm item-app:v1 is already there
docker images

# Before pushing the image to remote repository,
# we need to tag it with the remote repository namespace.
# Tag the local image with the remote repository namespace
docker tag item-app:v1 artworkspace/item-app:v1

# Setting up credentials for Docker Hub
# Put your access token in the environment variable PASSWORD_DOCKER_HUB
echo "$PASSWORD_DOCKER_HUB" | docker login -u artworkspace --password-stdin

# Push the image to Docker Hub
docker push artworkspace/item-app:v1