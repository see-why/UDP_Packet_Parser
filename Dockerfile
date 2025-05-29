FROM ruby:3.4.4-slim-bullseye

WORKDIR /app

# Install required packages and security updates
RUN apt-get update && apt-get install -y \
  iproute2 \
  net-tools \
  iputils-ping \
  tcpdump \
  libpcap-dev \
  build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Ruby gems
RUN gem install pcap

# Copy the Ruby files
COPY my_udp_server.rb .
COPY get_interface_index.rb .

# Create a non-root user
RUN useradd -m udpuser

# Switch to non-root user
USER udpuser

# Run the server
CMD ["ruby", "my_udp_server.rb"] 