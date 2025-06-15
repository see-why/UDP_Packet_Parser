# frozen_string_literal: true

require 'socket'
require 'ipaddr'

class UdpSocketManager
  def initialize
    @socket = Socket.new(Socket::AF_INET, Socket::SOCK_RAW, Socket::IPPROTO_RAW)
    # Tell the kernel not to add its own IP header
    @socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_HDRINCL, 1)
  end

  def send_packet(data, _offset, dest_ip, dest_port, source_ip: ENV.fetch('SOURCE_IP', '192.168.1.100'), source_port: ENV.fetch('SOURCE_PORT', '5000'))
    # Convert source_port to integer
    source_port = source_port.to_i
    dest_port = dest_port.to_i

    # For response, we use the original sender's IP as destination
    udp_packet = build_udp_packet(data, source_ip, dest_ip, source_port, dest_port)
    ip_packet = build_ip_packet(udp_packet, source_ip, dest_ip)

    # Send to the original sender
    sockaddr = Socket.sockaddr_in(dest_port, dest_ip)
    @socket.send(ip_packet, 0, sockaddr)
  end

  private

  def build_udp_packet(data, src_ip, dst_ip, src_port, dst_port)
    data = data.bytes
    length = 8 + data.size

    # UDP Header
    udp_header = [src_port, dst_port, length, 0].pack('nnnn')

    # Pseudo Header (for checksum)
    pseudo_header = IPAddr.new(src_ip).hton +
                    IPAddr.new(dst_ip).hton +
                    [0, Socket::IPPROTO_UDP, length].pack('CCn')

    checksum_data = pseudo_header + udp_header + data.pack('C*')
    checksum = udp_checksum(checksum_data)

    # Final UDP header with checksum
    [src_port, dst_port, length, checksum].pack('nnnn') + data.pack('C*')
  end

  def build_ip_packet(udp_segment, src_ip, dst_ip)
    version_ihl = (4 << 4) + 5
    tos = 0
    total_length = 20 + udp_segment.bytesize
    id = 54321
    flags_offset = 0
    ttl = 64
    protocol = Socket::IPPROTO_UDP
    header_checksum = 0
    src = IPAddr.new(src_ip).hton
    dst = IPAddr.new(dst_ip).hton

    ip_header = [version_ihl, tos, total_length, id, flags_offset,
                 ttl, protocol, header_checksum].pack('C2n3C2n') + src + dst

    ip_checksum = checksum(ip_header)
    ip_header[10..11] = [ip_checksum].pack('n')  # Set correct checksum

    ip_header + udp_segment
  end

  def udp_checksum(data)
    sum = checksum(data)
    sum == 0 ? 0xFFFF : sum
  end

  def checksum(data)
    data += "\x00" if data.bytesize.odd?
    sum = data.unpack('n*').sum

    while (sum >> 16) > 0
      sum = (sum & 0xFFFF) + (sum >> 16)
    end

    (~sum & 0xFFFF)
  end
end
