FROM kasmweb/ubuntu-jammy-desktop:1.16.0

USER root

# Add i386 architecture & install Wine
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget unzip xvfb x11vnc wine64 wine32 winetricks && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/optcg

# Build arg for private download
ARG PRIVATE_URL
ENV WINEPREFIX=/home/kasm-user/.wine
ENV DISPLAY=:1

# Download your installer
RUN wget -O optcg.zip "$PRIVATE_URL" && \
    unzip optcg.zip && rm optcg.zip

# Add start script
COPY start_optcg.sh /usr/local/bin/start_optcg.sh
RUN chmod +x /usr/local/bin/start_optcg.sh

USER 1000
ENTRYPOINT ["/usr/local/bin/start_optcg.sh"]
