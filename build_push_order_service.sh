#! /bin/bash

# Build order service image using Dockerfile in current directory
docker build -t fikriyusrihan/order-service:latest . --no-cache

# Tag order service image to be pushed to GitHub Container Registry
docker tag fikriyusrihan/order-service:latest ghcr.io/fikriyusrihan/order-service:latest

# Login to GitHub Container Registry using GitHub Personal Access Token
echo "$CR_PAT" | docker login ghcr.io -u fikriyusrihan --password-stdin

# Push order service image to GitHub Container Registry
docker push ghcr.io/fikriyusrihan/order-service:latest