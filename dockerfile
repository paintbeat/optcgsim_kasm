# Base Kasm Linux desktop
FROM kasmweb/ubuntu-jammy-desktop:1.16.0

USER root

# Unity/graphics/runtime deps + tools
RUN apt-get update && \
    apt-get install -y wget unzip libglu1-mesa libxcursor1 libxrandr2 libxi6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/optcg

# Pass the private download URL from a GitHub Secret
ARG PRIVATE_URL

# Download, extract, and make the binary executable
RUN wget -O 1.33a_Linux.zip "$PRIVATE_URL" && \
    unzip 1.33a_Linux.zip && \
    chmod +x OPTCGSim.x86_64 && \
    rm 1.33a_Linux.zip

# Startup script
COPY start_optcg.sh /usr/local/bin/start_optcg.sh
RUN chmod +x /usr/local/bin/start_optcg.sh

# Drop to the kasm-user
USER 1000

# Launch the game when the workspace starts
ENTRYPOINT ["/usr/local/bin/start_optcg.sh"]
