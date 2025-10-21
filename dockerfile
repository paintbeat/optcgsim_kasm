FROM kasmweb/ubuntu-jammy-desktop:1.16.0

USER root

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget unzip xvfb x11vnc wine64 wine32 winetricks && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/optcg

# Download from a private link (presigned URL or token-authenticated)
RUN wget -O optcg.zip "https://www.dropbox.com/scl/fi/6vji2p4uajuses2arq657/1.30d_Windows.zip?rlkey=657eqdgl4323wrlrjm6p8fsok&st=qzhuyjz0&dl=0" && \
    unzip 1.30d_Windows.zip && rm 1.30d_Windows.zip

COPY start_optcg.sh /usr/local/bin/start_optcg.sh
RUN chmod +x /usr/local/bin/start_optcg.sh

USER 1000
ENTRYPOINT ["/usr/local/bin/start_optcg.sh"]
