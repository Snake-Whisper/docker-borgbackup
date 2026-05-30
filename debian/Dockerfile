FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        borgbackup \
        openssh-server \
        ca-certificates \
        bash \
        tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# SSH Runtime-Verzeichnis
RUN mkdir -p /run/sshd

# Borg-Benutzer anlegen
RUN useradd \
        --create-home \
        --shell /bin/bash \
        --uid 1000 \
        borg

# Repository-Verzeichnis
RUN mkdir -p /borg/repository && \
    chown -R borg:borg /borg

# SSH-Verzeichnis
RUN mkdir -p /home/borg/.ssh && \
    chown -R borg:borg /home/borg/.ssh && \
    chmod 700 /home/borg/.ssh

# SSH-Konfiguration härten
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Borg-Zugriff erzwingen
RUN printf '\n\
Match User borg\n\
    PasswordAuthentication no\n\
    PermitTTY no\n\
    X11Forwarding no\n\
    AllowTcpForwarding no\n\
    ForceCommand borg serve --restrict-to-path /borg/repository\n' \
    >> /etc/ssh/sshd_config

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Host Keys werden persistent gespeichert
VOLUME ["/etc/ssh","/home/borg/.ssh","/borg/repository"]

EXPOSE 2222

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D","-e"]
