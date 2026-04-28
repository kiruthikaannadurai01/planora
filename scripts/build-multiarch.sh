#!/bin/bash

# Multi-Architecture Build Script
# Builds Docker images for multiple architectures and pushes to Docker Hub

set -e

# Configuration
DOCKER_HUB_USER="${DOCKER_HUB_USER:-yourdockerhub}"
PLATFORMS="linux/amd64,linux/arm64"

echo "🐳 Starting Multi-Architecture Build..."
echo "📦 Platforms: $PLATFORMS"

# Create buildx builder if it doesn't exist
if ! docker buildx inspect multi-arch &>/dev/null; then
    echo "✨ Creating buildx builder..."
    docker buildx create --name multi-arch --use
else
    echo "✅ Using existing buildx builder"
    docker buildx use multi-arch
fi

# Build Backend
echo "🔨 Building Backend..."
docker buildx build \
  --platform $PLATFORMS \
  -t $DOCKER_HUB_USER/backend:latest \
  --push \
  ./backend

# Build Frontend
echo "🔨 Building Frontend..."
docker buildx build \
  --platform $PLATFORMS \
  -t $DOCKER_HUB_USER/frontend:latest \
  --push \
  ./frontend

echo "✅ Multi-Architecture Build Complete!"
echo "📍 Images pushed to Docker Hub: $DOCKER_HUB_USER"
