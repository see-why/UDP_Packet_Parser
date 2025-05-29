#!/bin/bash

# Remove existing container if it exists
echo "Cleaning up existing container..."
docker rm -f udp-server-container 2>/dev/null || true

# Create a custom network if it doesn't exist
echo "Setting up custom network..."
docker network create --driver bridge udp-network 2>/dev/null || true

# Build the image
echo "Building Docker image..."
docker build -t udp-server .

# Run the container
echo "Starting container..."
docker run --cap-add=NET_RAW \
           --cap-add=NET_ADMIN \
           --network=udp-network \
           --name udp-server-container \
           -p 5000:5000/udp \
           -it udp-server