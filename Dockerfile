FROM ruby:3.2

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y \
  iproute2 \
  net-tools \
  iputils-ping \
  tcpdump \
  && rm -rf /var/lib/apt/lists/*

# Copy the Ruby files
COPY my_udp_server.rb .
COPY get_interface_index.rb .

# Create a non-root user
RUN useradd -m udpuser

# Switch to non-root user
USER udpuser

# Run the server
CMD ["ruby", "my_udp_server.rb"] 