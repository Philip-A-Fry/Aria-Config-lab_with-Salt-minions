# Use the official Ubuntu latest base image
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y salt-minion && \
    rm -rf /var/lib/apt/lists/*

# Update package lists and install ping and ifconfig
RUN apt-get update && apt-get install -y iputils-ping net-tools netcat && rm -rf /var/lib/apt/lists/*

# Set the Salt Master IP
RUN echo "master: aria-config-docker-lab-salt-master-1" >> /etc/salt/minion

# Start the Salt Minion service
CMD ["salt-minion", "-l", "info"]

