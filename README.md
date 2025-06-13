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
   - UDP packet data
   - Source IP address
   - Source port

## Testing

To send test packets to the server, you can use netcat:

```bash
# Send a test packet (with newline)
echo "Test packet" | nc -u localhost 5000

# Send a test packet (without newline)
echo -n "Test packet" | nc -u localhost 5000
```

Or use the provided Python script:

```bash
python3 scripts/send_udp.py
```

## Packet Structure

The server parses the following packet layers:

1. Ethernet Frame (14 bytes):
   - Destination MAC (6 bytes)
   - Source MAC (6 bytes)
   - Ethertype (2 bytes)

2. IPv4 Header (20+ bytes):
   - Version and IHL
   - Total Length
   - Protocol
   - Source IP Address
   - Destination IP Address

3. UDP Header (8 bytes):
   - Source Port
   - Destination Port
   - Length
   - Checksum

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

4. Check packet capture:

```bash
docker exec udp-server-container tcpdump -i eth0 -n udp port 5000
```

5. Common issues:
   - "No such device" error: The interface specified doesn't exist in the container
   - Permission denied: Container might not have the required capabilities
   - Network unreachable: Check if the Docker network is properly configured
   - Packet truncation: Try using `-n` with echo to prevent newline addition

## Security Note

This server requires root privileges to capture raw packets. The Docker container is configured with the necessary capabilities (`NET_RAW` and `NET_ADMIN`), but be careful when running it in production environments.
