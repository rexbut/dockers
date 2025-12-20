ARG HOMEASSISTANT_VERSION

FROM homeassistant/home-assistant:${HOMEASSISTANT_VERSION}

# Ldap
RUN apk add --no-cache \
        openldap-clients \
        libcap \
        ffmpeg \
        ffmpeg-libs \
    && setcap 'cap_net_raw,cap_net_admin+eip' `readlink -f \`which python3\`` \
    && setcap 'cap_net_raw+ep' `readlink -f \`which hcitool\``

ENTRYPOINT ["/init"]
