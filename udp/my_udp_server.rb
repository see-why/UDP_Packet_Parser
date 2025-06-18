# frozen_string_literal: true

require 'pcap'
require 'hexdump'
require_relative 'get_interface_index'
require_relative '../managers/ethernet_frame_manager'
require_relative '../managers/udp_socket_manager'

BUFFER_SIZE = 65_535
ETH_P_ALL = 0x0300
SOCKADDR_LL_SIZE = 0x0014
UDP_PROTOCOL = 0x11

def bind_socket(interface_name)
  socket, index = get_interface_index(interface_name)

  sockaddr_ll = [Socket::AF_PACKET].pack('s')
  sockaddr_ll << [ETH_P_ALL].pack('s')
  sockaddr_ll << index
  sockaddr_ll << ("\x00" * (SOCKADDR_LL_SIZE - sockaddr_ll.length))

  socket.bind(sockaddr_ll)
  socket
end

def start_server
  puts 'Starting low-level packet capture on interface eth0...'
  puts 'Note: This requires root privileges to run'

  begin
    socket = bind_socket(ENV.fetch('NETWORK_INTERFACE', 'eth0'))
    puts 'Server is ready to receive packets...'
    puts 'Listening on Docker network interface...'

    loop do
      data = socket.recv(BUFFER_SIZE)
      puts "\nPackets received..."
      Hexdump.dump(data)

      # Extract the EtherType field (bytes 12-13 of the Ethernet frame)
      ether_type = data[12..13].unpack1('n')

      # Only process IPv4 frames (EtherType 0x0800)
      next unless ether_type == 0x0800
      frame = EthernetFrameManager.new(data)
      protocol = frame.ip_packet_manager.protocol

      next unless protocol == UDP_PROTOCOL &&
                  frame.ip_packet_manager.udp_datagram.destination_port == 5000

      puts "data: #{frame.ip_packet_manager.udp_datagram.body}"
      puts "source ip: #{frame.ip_packet_manager.source_ip_address}"
      puts "source port: #{frame.ip_packet_manager.udp_datagram.source_port}"

      UdpSocketManager.new.send_packet(
        frame.ip_packet_manager.udp_datagram.body.upcase,
        0,
        frame.ip_packet_manager.source_ip_address,
        frame.ip_packet_manager.udp_datagram.source_port
      )

      puts "********** Packets sent **********"
    end
  rescue StandardError => e
    puts "Error: #{e.message}"
    puts e.backtrace
  end
end

start_server
