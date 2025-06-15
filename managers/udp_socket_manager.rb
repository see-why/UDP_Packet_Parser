# frozen_string_literal: true

require 'socket'
require 'ipaddr'

class UdpSocketManager
  def initialize
    @socket = Socket.new(Socket::AF_INET, Socket::SOCK_RAW, Socket::IPPROTO_RAW)
  end

  def send(data, _offset, dest_ip, dest_port, source_ip: ENV.fetch('SOURCE_IP', '192.168.1.100'), source_port: ENV.fetch('SOURCE_PORT', '5000'))
    # Convert source_port to integer
    source_port = source_port.to_i
    dest_port = dest_port.to_i

    udp_header = build_udp_header(data.bytesize, source_port, dest_port)
    ip_header = build_ip_header(data.bytesize + udp_header.bytesize, source_ip, dest_ip)

    packet = ip_header + udp_header + data
    sockaddr = Socket.sockaddr_in(dest_port, dest_ip)

    @socket.send(packet, 0, sockaddr)
  end

  private

  def build_udp_header(payload_size, source_port, dest_port)
    udp_length = 8 + payload_size
    [
      source_port,     # Source Port
      dest_port,       # Destination Port
      udp_length,      # Length
      0                # Checksum (set to 0 for simplicity)
    ].pack('nnnn')
  end

  def build_ip_header(total_length, source_ip, dest_ip)
    version_ihl = (4 << 4) + 5
    tos = 0
    id = 54321
    flags_frag_offset = 0
    ttl = 64
    protocol = Socket::IPPROTO_UDP
    checksum = 0 # For simplicity; OS may fill it in
    src_addr = IPAddr.new(source_ip).hton
    dst_addr = IPAddr.new(dest_ip).hton

    [
      version_ihl,
      tos,
      total_length,
      id,
      flags_frag_offset,
      ttl,
      protocol,
      checksum
    ].pack('C2n3C2n') + src_addr + dst_addr
  end
end
