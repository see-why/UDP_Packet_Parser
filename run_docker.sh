#!/bin/bash

# Build the image
echo "Building Docker image..."
docker build -t udp-server .

# Run the container
echo "Starting container..."
docker run --cap-add=NET_RAW \
           --cap-add=NET_ADMIN \
           --network=host \
           -it udp-server 