# frozen_string_literal: true

class IPPacketManager
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def version
    bytes[0] >> 4
  end

  def ihl
    bytes[0] & 0xF
  end

  def protocol
    bytes[9]  # Protocol field is at offset 9 in IPv4 header
  end

  def source_ip_address
    bytes[14, 4].join('.')
  end
end
