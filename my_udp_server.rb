# frozen_string_literal: true

require 'socket'
require 'hexdump'

BUFFER_SIZE = 1024
PORT = 12345

def bind_socket(interface_name)
  # Create a raw socket for IPv4
  socket = Socket.new(Socket::PF_INET, Socket::SOCK_RAW, Socket::IPPROTO_UDP)

  # Set socket options to include IP headers
  socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_HDRINCL, 1)

  # Bind to the interface
  socket.bind(Socket.pack_sockaddr_in(PORT, '0.0.0.0'))

  socket
end

def parse_ip_header(data)
  # IP header is first 20 bytes
  version_ihl, tos, total_length, id, flags_frag, ttl, protocol, checksum,
  src_ip, dst_ip = data.unpack('CCnnnCCnNN')

  {
    version: (version_ihl >> 4),
    ihl: (version_ihl & 0x0F),
    tos: tos,
    total_length: total_length,
    id: id,
    ttl: ttl,
    protocol: protocol,
    src_ip: [src_ip].pack('N').unpack('C4').join('.'),
    dst_ip: [dst_ip].pack('N').unpack('C4').join('.')
  }
end

def parse_udp_header(data)
  # UDP header starts after IP header (20 bytes)
  src_port, dst_port, length, checksum = data[20, 8].unpack('nnnn')

  {
    src_port: src_port,
    dst_port: dst_port,
    length: length,
    checksum: checksum
  }
end

def start_server
  puts "Starting raw socket UDP server on port #{PORT}..."
  puts "Note: This requires root privileges to run"
  socket = bind_socket('en1')

  loop do
    data = socket.recv(BUFFER_SIZE)

    # Parse headers
    ip_header = parse_ip_header(data)
    udp_header = parse_udp_header(data)

    puts "\nReceived packet:"
    puts "IP Header:"
    puts "  Source: #{ip_header[:src_ip]}"
    puts "  Destination: #{ip_header[:dst_ip]}"
    puts "  Protocol: #{ip_header[:protocol]}"
    puts "UDP Header:"
    puts "  Source Port: #{udp_header[:src_port]}"
    puts "  Destination Port: #{udp_header[:dst_port]}"
    puts "  Length: #{udp_header[:length]}"
    puts "Raw packet data:"
    Hexdump.dump(data)
  end
end

start_server
