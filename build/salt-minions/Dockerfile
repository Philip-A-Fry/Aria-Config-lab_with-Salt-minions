# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg software-properties-common && \
    curl -L https://bootstrap.saltstack.com -o bootstrap-salt.sh && \
    sh bootstrap-salt.sh -P -M -X && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install necessary tools
RUN apt-get update && apt-get install -y iputils-ping net-tools netcat && rm -rf /var/lib/apt/lists/*

# Set the Salt Master IP
RUN echo "master: aria-config-lab_with-5-salt-minions-salt-master-1" >> /etc/salt/minion

# Start the Salt Minion service
CMD ["salt-minion", "-l", "info"]