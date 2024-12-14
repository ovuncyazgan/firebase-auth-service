#!/bin/bash

VERSION=$(node -p "require('./package.json').version")
IMAGE_NAME="ghcr.io/ovuncyazgan/firebase-auth-service"

if [ -z "$VERSION" ]; then 
    echo "Error: Version not found in package.json"
    exit 1
fi

echo Building Docker Image $IMAGE_NAME:$VERSION
docker build --platform linux/amd64 -t "$IMAGE_NAME:$VERSION" .

echo "Pushing Docker image: $IMAGE_NAME:$VERSION"
docker push "$IMAGE_NAME:$VERSION"

# Optionally, tag as latest and push
echo "Tagging and pushing Docker image as 'latest'"
docker tag "$IMAGE_NAME:$VERSION" "$IMAGE_NAME:latest"
docker push "$IMAGE_NAME:latest"


echo "Docker image build and push complete!"