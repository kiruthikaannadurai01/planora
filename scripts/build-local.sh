#!/bin/bash

# Local Development Build Script
# Builds Docker images for local testing with docker-compose

echo "🐳 Building Docker images locally..."
docker-compose build

echo "✅ Build complete! Run 'docker-compose up' to start services"
