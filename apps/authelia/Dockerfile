ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/authelia/authelia:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.2

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk --no-cache add yq

ENV SKIP_FILE_SECRETS_EXPANSION=1

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=source /app/authelia /usr/bin/authelia

USER 65000:65000

EXPOSE 9091
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh", "/usr/bin/authelia", "--config", "/tmp/configuration.yaml"]

LABEL org.opencontainers.image.source="https://github.com/authelia/authelia/"
