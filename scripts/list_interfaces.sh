#!/bin/bash

echo "Listing available network interfaces in the container..."
echo "====================================================="

docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN --network=host udp-server ip addr | grep -A 2 "^[0-9]*: " | grep -v "^--$" | while read -r line; do
  if [[ $line =~ ^[0-9]+: ]]; then
    echo ""
    echo "$line"
  elif [[ $line =~ "state" ]]; then
    echo "$line"
  elif [[ $line =~ "inet" ]]; then
    echo "$line"
  fi
done

echo ""
echo "To use an interface, update the interface name in my_udp_server.rb"
echo "Look for interfaces that are in the 'UP' state" 