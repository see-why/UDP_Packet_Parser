# frozen_string_literal: true

require_relative 'ip_packet_manager'

class EthernetFrameManager
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def ip_packet_manager
    IPPacketManager.new(bytes[14..])
  end

  def destination_mac
    format_mac(bytes[0, 6])
  end

  def source_mac
    format_mac(bytes[6, 6])
  end

  def ether_type
    (bytes[12].ord << 8 | bytes[13].ord).to_s(16).rjust(4, '0').upcase
  end

  private

  def format_mac(mac_bytes)
    mac_bytes.map { |byte| byte.to_s(16).rjust(2, '0') }.join(':').upcase
  end
end
