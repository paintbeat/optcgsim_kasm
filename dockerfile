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
# Robust direct download + sanity checks + resilient chmod
RUN apt-get update && apt-get install -y wget unzip ca-certificates && \
    wget -L --quiet --show-progress --https-only --retry-connrefused --waitretry=1 -t 5 \
      -O /tmp/optcg.zip "$PRIVATE_URL" && \
    # sanity check size (>100KB)
    test $(stat -c%s /tmp/optcg.zip) -gt 100000 || (echo "Downloaded file too small; check PRIVATE_URL" && exit 2) && \
    unzip -o /tmp/optcg.zip -d /opt/optcg && \
    # handle possible folder names and binary names
    BIN_PATH=$(find /opt/optcg -type f -name "*OPTCG*Sim*.x86_64" | head -n 1) && \
    test -n "$BIN_PATH" || (echo "OPTCG binary not found after unzip" && exit 3) && \
    chmod +x "$BIN_PATH" && \
    ln -sf "$BIN_PATH" /opt/optcg/OPTCGSim.x86_64 && \
    rm -f /tmp/optcg.zip

# Startup script
COPY start_optcg.sh /usr/local/bin/start_optcg.sh
RUN chmod +x /usr/local/bin/start_optcg.sh

# Drop to the kasm-user
USER 1000

# Launch the game when the workspace starts
ENTRYPOINT ["/usr/local/bin/start_optcg.sh"]
