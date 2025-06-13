# frozen_string_literal: true

class UDPDatagramManager
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def source_port
    word16(bytes[0], bytes[1])
  end

  def destination_port
    word16(bytes[2], bytes[3])
  end

  def length
    word16(bytes[4], bytes[5])
  end

  def checksum
    word16(bytes[6], bytes[7])
  end

  def word16(a, b)
    (a << 8) | b  # Use bitwise OR to combine the bytes
  end

  def body
     bytes[8, (length - 8)].pack('C*')
  end
end
