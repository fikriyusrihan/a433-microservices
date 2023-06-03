#! /bin/bash

# Build item-app image using Dockerfile in current directory
# Tag the image with v1
docker build -t fikriyusrihan/karsajobs-ui:latest .

# Show all local images to confirm fikriyusrihan/karsajobs:latest is already there
docker images

# Before pushing the image to remote repository,
# we need to tag it with the remote repository namespace.
# Tag the local image with the remote repository namespace.
docker tag fikriyusrihan/karsajobs-ui:latest ghcr.io/fikriyusrihan/karsajobs-ui:latest

# Setting up credentials for GitHub Package
# Put your access token in the environment variable CR_PAT
echo "$CR_PAT" | docker login ghcr.io -u fikriyusrihan --password-stdin

# Push the image to GitHub Package
docker push ghcr.io/fikriyusrihan/karsajobs-ui:latest