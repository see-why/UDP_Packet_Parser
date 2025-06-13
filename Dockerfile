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
RUN gem install ruby-pcap hexdump

# Copy the Ruby files maintaining directory structure
COPY udp/ ./udp/
COPY managers/ ./managers/

# Run the server
CMD ["ruby", "udp/my_udp_server.rb"] 