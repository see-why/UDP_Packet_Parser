# frozen_string_literal: true

class UDPDatagramManager
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def source_port
    word16(bytes[0].ord, bytes[1].ord)
  end

  def destination_port
    word16(bytes[2].ord, bytes[3].ord)
  end

  def length
    word16(bytes[4].ord, bytes[5].ord)
  end

  def checksum
    word16(bytes[6].ord, bytes[7].ord)
  end

  def word16(a, b)
    (a << 8) | b  # Use bitwise OR to combine the bytes
  end

  def body
     bytes[8, (length - 8)].pack('C*')
  end
end
