# UDP Packet Capture Server

A Ruby-based UDP packet capture server that uses raw sockets to capture and display network packets.

## Prerequisites

- Docker
- Ruby 3.4.4 (handled by Docker)
- Required gems: pcap, hexdump

## Setup

1. Build and run the Docker container:
```bash
./run_docker.sh
```

## Finding Network Interfaces

To list available network interfaces in the container:
```bash
docker run --rm --cap-add=NET_RAW --cap-add=NET_ADMIN --network=host udp-server ip addr
```

Look for interfaces that are in the "UP" state. Common interfaces include:
- `eth0`: Main Ethernet interface
- `services1`: Docker service interface
- `lo`: Loopback interface
- `docker0`: Docker bridge interface

## Usage

The server will capture all packets on the specified interface and display:
- Packet timestamp
- Packet length
- Hex dump of packet contents

## Testing

To send test packets to the server, you can use netcat:
```bash
echo "Test packet" | nc -u localhost 1234
```

## Troubleshooting

If you get a "No such device" error:
1. Check available interfaces using the command above
2. Update the interface name in `my_udp_server.rb` to match an available interface
3. Make sure the container has the necessary capabilities (`NET_RAW` and `NET_ADMIN`)

## Security Note

This server requires root privileges to capture raw packets. The Docker container is configured with the necessary capabilities, but be careful when running it in production environments.
