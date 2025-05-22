require 'socket'

BUFFER_SIZE = 1024

socket = UDPSocket.new
socket.bind('127.0.2.3', 4321)

loop do
  puts 'Server running...'
  message, sender = socket.recvfrom(BUFFER_SIZE)

  port = sender[1]
  host = sender[2]

  puts "sender host: #{host} port: #{port}"

  socket.send(message.upcase, 0, host, port)
end
