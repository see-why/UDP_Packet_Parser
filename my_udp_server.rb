# frozen_string_literal: true

require 'pcap'
require 'hexdump'

BUFFER_SIZE = 1024
ETH_P_ALL = 0x0300

def bind_socket(interface_name)
  # Open the network interface in promiscuous mode
  # This allows us to capture all packets, not just those destined for our interface
  cap = Pcap::Capture.open_live(interface_name, BUFFER_SIZE, true, 0)

  # Set a filter to capture all packets
  cap.setfilter("")

  cap
end

def start_server
  puts "Starting low-level packet capture on interface en1..."
  puts "Note: This requires root privileges to run"

  begin
    cap = bind_socket('en1')
    puts "Server is ready to receive packets..."

    cap.loop do |packet|
      puts "\nReceived packet:"
      puts "Timestamp: #{packet.time}"
      puts "Length: #{packet.len} bytes"
      puts "Raw packet data:"
      Hexdump.dump(packet.body)
    end
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace
  end
end

start_server
