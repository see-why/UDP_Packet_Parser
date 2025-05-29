# frozen_string_literal: true

require 'pcap'
require 'hexdump'
require_relative 'get_interface_index'

BUFFER_SIZE = 1024
ETH_P_ALL = 0x0300
SOCKADDR_LL_SIZE = 0x0014

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
  puts "Starting low-level packet capture on interface eth0..."
  puts "Note: This requires root privileges to run"

  begin
    socket = bind_socket('eth0')
    puts "Server is ready to receive packets..."
    puts "Listening on Docker network interface..."

    loop do
      data = socket.recv(BUFFER_SIZE)
      puts "Packets received..."
      Hexdump.dump(data)
      puts "Packets sent..."
    end
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace
  end
end

start_server
