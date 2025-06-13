# frozen_string_literal: true

require_relative 'udp_datagram_manager'

class IPPacketManager
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def udp_datagram
    header_length = ihl * 4 # IHL is in 32-bit words
    UDPDatagramManager.new(bytes.bytes.drop(header_length))
  end

  def version
    bytes.getbyte(0) >> 4
  end

  def ihl
    bytes.getbyte(0) & 0xF
  end

  def protocol
    bytes.getbyte(9) # Protocol field is at offset 9 in IPv4 header
  end

  def source_ip_address
    bytes[12, 4].bytes.join('.')
  end
end
