FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages at build time
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    openssh-server sudo curl ca-certificates procps \
 && rm -rf /var/lib/apt/lists/*

# Create a non-root user and give sudo (no password) for convenience (adjust for security)
RUN useradd -m -s /bin/bash dev \
 && echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev \
 && chmod 0440 /etc/sudoers.d/dev

# Setup SSH
RUN mkdir /var/run/sshd \
 && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
 && sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config \
 && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Add your public key (replace with your actual key or use build ARGs / secrets)
# Example: copy public key from repo at build time (safer: pass as secret)
COPY id_rsa.pub /home/dev/.ssh/authorized_keys
RUN chown -R dev:dev /home/dev/.ssh && chmod 700 /home/dev/.ssh && chmod 600 /home/dev/.ssh/authorized_keys

EXPOSE 22

# Use a lightweight process supervisor to run multiple processes if needed
RUN apt-get update && apt-get install -y --no-install-recommends supervisor && rm -rf /var/lib/apt/lists/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
