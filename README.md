# UDP Packet Capture Server

A Ruby-based UDP packet capture server that uses raw sockets to capture and display network packets.

## Prerequisites

- Docker
- Ruby 3.4.4 (handled by Docker)
- Required gems: pcap, hexdump

## Setup

1. Build and run the Docker container:

```bash
./scripts/run_docker.sh
```

The server will automatically:

- Create a custom Docker network (udp-network)
- Build the Docker image
- Run the container with necessary capabilities
- Bind to the eth0 interface inside the container

## Network Interface

The server is configured to use the `eth0` interface by default, which is the main network interface inside the Docker container. This is set via the `NETWORK_INTERFACE` environment variable.

To verify the network interface in the container:

```bash
docker exec udp-server-container ip addr
```

## Usage

The server will:

1. Bind to the specified network interface (default: eth0)
2. Capture all packets on that interface
3. Display:
   - Hex dump of packet contents

## Testing

To send test packets to the server, you can use netcat:

```bash
echo "Test packet" | nc -u localhost 5000
```

Or use the provided Python script:

```bash
python3 udp/send_udp.py
```

## Troubleshooting

If you encounter issues:

1. Check if the container is running:

```bash
docker ps | grep udp-server-container
```

2. View container logs:

```bash
docker logs udp-server-container
```

3. Verify network interface:

```bash
docker exec udp-server-container ip addr
```

4. Common issues:
   - "No such device" error: The interface specified doesn't exist in the container
   - Permission denied: Container might not have the required capabilities
   - Network unreachable: Check if the Docker network is properly configured

## Security Note

This server requires root privileges to capture raw packets. The Docker container is configured with the necessary capabilities (`NET_RAW` and `NET_ADMIN`), but be careful when running it in production environments.
