# TeamSpeak 3 Server - ARM64 (via Box64 emulation)
# Based on official TeamSpeak Alpine image structure

ARG TS3_VERSION=3.13.7
ARG DEBIAN_VERSION=bookworm-slim

FROM debian:${DEBIAN_VERSION}

ARG TS3_VERSION

LABEL maintainer="remi.butet@evercraft.fr" \
      description="TeamSpeak 3 Server for ARM64 (using Box64 emulation)" \
      version="${TS3_VERSION}"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    tar \
    bzip2 \
    ca-certificates \
    xz-utils \
    gnupg \
    locales \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install Box64 from official repository
RUN wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/box64-archive-keyring.gpg] https://ryanfortner.github.io/box64-debs/debian/ ./" > /etc/apt/sources.list.d/box64.list \
    && apt-get update && apt-get install -y box64 \
    && rm -rf /var/lib/apt/lists/*

# Create user and directories (matching official image structure)
RUN set -eux; \
    groupadd -g 9987 ts3server; \
    useradd -u 9987 -d /var/ts3server -g ts3server -s /sbin/nologin ts3server; \
    install -d -o ts3server -g ts3server -m 775 /var/ts3server /var/run/ts3server /opt/ts3server

# Configure locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen en_US.UTF-8

ENV PATH="${PATH}:/opt/ts3server"

# Download TeamSpeak server (Linux x86_64 version for Box64)
RUN set -eux; \
    wget "https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2" -O server.tar.bz2; \
    tar -xf server.tar.bz2 --strip-components=1 -C /opt/ts3server; \
    rm server.tar.bz2; \
    touch /opt/ts3server/.ts3server_license_accepted; \
    chown -R ts3server:ts3server /opt/ts3server

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh /opt/ts3server/

# Environment variables
ENV TS3SERVER_LICENSE=accept \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    BOX64_LOG=0 \
    BOX64_NOBANNER=1 \
    BOX64_LD_LIBRARY_PATH=/opt/ts3server:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu

# Setup directory where user data is stored
VOLUME /var/ts3server/
WORKDIR /var/ts3server/

# Exposed ports:
#  9987/udp : Voice
# 10011/tcp : ServerQuery
# 10022/tcp : ServerQuery SSH
# 30033/tcp : File transfer
EXPOSE 9987/udp 10011 10022 30033

ENTRYPOINT ["entrypoint.sh"]
CMD ["ts3server"]
