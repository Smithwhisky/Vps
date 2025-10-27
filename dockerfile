FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop and xRDP
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-goodies xrdp dbus-x11 x11-xserver-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user with password
RUN useradd -m -s /bin/bash dev && echo 'dev:1234' | chpasswd && \
    usermod -aG sudo dev && \
    echo xfce4-session > /home/dev/.xsession && \
    chown dev:dev /home/dev/.xsession

# Configure xRDP
RUN sed -i.bak '/^test -x/a startxfce4 &' /etc/xrdp/startwm.sh
EXPOSE 3389

CMD ["/usr/sbin/xrdp", "-nodaemon"]
