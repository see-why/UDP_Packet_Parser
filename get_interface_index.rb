# frozen_string_literal: true

require 'socket'

IFREQ_SIZE = 0x0028
IFINDEX_SIZE = 0x0004
SIOCGIFINDEX = 0x8933

def get_interface_index(interface_name)
  socket = Socket.open(:PACKET, :RAW)
  begin
    ifreq = [interface_name].pack("a#{IFREQ_SIZE}")

    socket.ioctl(SIOCGIFINDEX, ifreq)

    ifreq[Socket::IFNAMSIZ, IFINDEX_SIZE]
  ensure
    socket.close
  end
end
