ARG VERSION
FROM ghcr.io/deedee-ops/alpine:3.21.2 as builder

FROM ghcr.io/onedr0p/home-assistant:${VERSION}

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN apk --update add --no-cache \
    bind-tools \
    ca-certificates \
    curl \
    iputils \
    jq \
    netcat-openbsd \
    openssl \
    tini \
    tzdata \
 && addgroup -S abc --gid 65000 \
 && adduser -S abc -G abc --uid 65000 \
 && chown -R abc:abc /config

COPY --from=builder /usr/bin/envdir /usr/bin/envdir
COPY --from=builder /usr/bin/envsubst /usr/bin/envsubst
COPY --from=builder /usr/local/bin/base-entrypoint.sh /usr/local/bin/base-entrypoint.sh

USER 65000:65000
EXPOSE 8123
VOLUME ["/tmp"]
ENTRYPOINT ["/usr/local/bin/base-entrypoint.sh"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/home-assistant/core"
