# Chill Network Stack

A lightweight and easy-to-use network stack implementation in Ruby.

## Features

- UDP server and client implementation
- Simple API for network communication
- Built with Ruby's standard library

## Installation

```bash
git clone https://github.com/yourusername/chill_network_stack.git
cd chill_network_stack
```

## Usage

### UDP Server Example

```ruby
require_relative 'lib/udp_server'

server = UDPServer.new('127.0.0.1', 4321)
server.start do |message, sender|
  puts "Received: #{message} from #{sender}"
end
```

### UDP Client Example

```ruby
require_relative 'lib/udp_client'

client = UDPClient.new
response = client.send_message("Hello Server!", '127.0.0.1', 4321)
puts "Server response: #{response}"
```

## Development

To run the tests:

```bash
ruby test/test_udp_server.rb
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
