#! /bin/bash

# Build order service image using Dockerfile in current directory
docker build -t fikriyusrihan/shipping-service:latest .

# Tag order service image to be pushed to GitHub Container Registry
docker tag fikriyusrihan/shipping-service:latest ghcr.io/fikriyusrihan/shipping-service:latest

# Login to GitHub Container Registry using GitHub Personal Access Token
echo "$CR_PAT" | docker login ghcr.io -u fikriyusrihan --password-stdin

# Push order service image to GitHub Container Registry
docker push ghcr.io/fikriyusrihan/shipping-service:latest