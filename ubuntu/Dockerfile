FROM ubuntu:22.04

# disable questions when installing packages
ENV DEBIAN_FRONTEND=noninteractive

LABEL company="EverCraft"

ARG UID=1001
ARG GID=1001
RUN groupadd -g $GID -o everuser && \
    useradd -m -u $UID -g $GID -o -s /bin/bash everuser

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# Base tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl nano zip unzip jq git && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Target and Python-libs
RUN mkdir -p /workdir && \
    chown -R everuser:everuser /workdir

USER everuser

WORKDIR /workdir
