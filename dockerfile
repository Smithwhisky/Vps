FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TAILSCALE_AUTH_KEY=""

RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies xrdp curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add RDP user
RUN useradd -m -s /bin/bash dev && echo 'dev:1234' | chpasswd && \
    usermod -aG sudo dev && \
    echo xfce4-session > /home/dev/.xsession && chown dev:dev /home/dev/.xsession

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Expose RDP
EXPOSE 3389

CMD tailscaled & sleep 5 && tailscale up --authkey=$TAILSCALE_AUTH_KEY && /usr/sbin/xrdp -nodaemon
