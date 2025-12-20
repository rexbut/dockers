# TeamSpeak 3 Server - ARM64 (via Box64 emulation)
# Utilise le dépôt Box64 officiel pour une installation simplifiée

ARG TS3_VERSION=3.13.7
ARG DEBIAN_VERSION=bookworm-slim

FROM debian:${DEBIAN_VERSION}

ARG TS3_VERSION

LABEL maintainer="remi.butet@evercraft.fr" \
      description="TeamSpeak 3 Server for ARM64 (using Box64 emulation)" \
      version="${TS3_VERSION}"

# 1. Installation des dépendances nécessaires
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

# 2.s Installation de Box64 depuis le dépôt officiel
RUN wget -O- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/box64-archive-keyring.gpg] https://ryanfortner.github.io/box64-debs/debian/ ./" > /etc/apt/sources.list.d/box64.list \
    && apt-get update && apt-get install -y box64 \
    && rm -rf /var/lib/apt/lists/*

# 3. Configuration de TeamSpeak
WORKDIR /opt/teamspeak

# 4. Téléchargement du serveur TeamSpeak (Version Linux x86_64)
RUN wget https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 \
    && tar -xjf teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 --strip-components=1 \
    && rm teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2

# Create user with fixed UID/GID
RUN groupadd -r -g 1000 teamspeak \
    && useradd -r -u 1000 -g teamspeak -d /opt/teamspeak -s /bin/bash teamspeak

# Setup directories and license acceptance
RUN touch .ts3server_license_accepted \
    && mkdir -p /data \
    && chown -R teamspeak:teamspeak /opt/teamspeak /data

# Configuration des locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen en_US.UTF-8

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Switch to non-root user
USER teamspeak

# 5. Accepter la licence (Variable d'environnement par défaut)
ENV TS3SERVER_LICENSE=accept \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TS3SERVER_DB_PLUGIN=ts3db_sqlite3 \
    TS3SERVER_DB_SQLCREATEPATH=create_sqlite \
    TS3SERVER_QUERY_PROTOCOLS=raw,ssh \
    BOX64_LOG=0 \
    BOX64_NOBANNER=1

# 6. Ports exposés
# 9987/udp : Voix
# 10011/tcp : ServerQuery
# 10022/tcp : ServerQuery SSH
# 30033/tcp : Transfert de fichiers
EXPOSE 9987/udp 10011/tcp 10022/tcp 30033/tcp

# Data volume
VOLUME ["/data"]

# Start TeamSpeak server via entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
