FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y openssh-server sudo curl vim && \
    mkdir /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# Create a user (named 'dev') with password "1234" — you can change it below
RUN useradd -m -s /bin/bash dev && echo 'dev:1234' | chpasswd && \
    usermod -aG sudo dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev && chmod 0440 /etc/sudoers.d/dev

# Enable password login (disable root login for safety)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Optional: change SSH port if you prefer (default 22)
EXPOSE 22

# Start SSH
CMD ["/usr/sbin/sshd", "-D"]
