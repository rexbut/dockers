ARG GITHUB_REGISTRY

FROM ${GITHUB_REGISTRY}/ubuntu:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends nut-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /config

COPY entrypoint.sh /entrypoint.sh