FROM ghcr.io/deedee-ops/alpine:3.20.1

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /usr/src

#hadolint ignore=DL3018
RUN REF="$( ([ "${CHANNEL}" = "stable" ] && echo "tags/v${VERSION}") || true)" \
 && REF="$( ([ "${CHANNEL}" = "devel" ] && echo "heads/master") || echo "${REF}" )" \
 && apk add --no-cache ca-certificates curl python3 py3-pip \
 && apk add --no-cache --virtual .build-deps alpine-sdk bash krb5-dev libffi-dev python3-dev \
 && mkdir -p /config /data \
 && rm -rf /usr/lib/python3.*/EXTERNALLY-MANAGED \
 && curl -fL -o "offlineimap3-${VERSION}.tar.gz" "https://github.com/OfflineIMAP/offlineimap3/archive/refs/${REF}.tar.gz" \
 && tar -xzf "offlineimap3-${VERSION}.tar.gz" \
 && sed -i'' "s@rfc6555@rfc6555', 'keyring@g" offlineimap3-*/setup.py \
 && sed -i'' 's@rfc6555@rfc6555", "keyring@g' offlineimap3-*/pyproject.toml \
 && sh -c "cd offlineimap3-*/ && pip install --no-cache-dir -r requirements.txt && make && pip install --no-cache-dir ." \
 && rm -rf offlineimap* \
 && apk del .build-deps

WORKDIR /config

USER 65000:65000
VOLUME ["/tmp"]
ENTRYPOINT ["/usr/local/bin/base-entrypoint.sh"]
CMD ["/usr/bin/offlineimap", "-c", "/config/offlineimap.conf"]

LABEL org.opencontainers.image.source="https://github.com/OfflineIMAP/offlineimap3/"
