ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/authelia/authelia:${VERSION} as source

FROM ghcr.io/deedee-ops/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3008
RUN set -eux \
 && apt-get update \
 && apt-get install --yes --no-install-recommends gnupg2 software-properties-common \
 && add-apt-repository -y ppa:rmescandon/yq \
 && apt-get update \
 && apt-get install --yes --no-install-recommends yq \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/share/man /usr/local/man /usr/local/share/man

ENV SKIP_FILE_SECRETS_EXPANSION=1

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=source /app/authelia /usr/bin/authelia

USER 65000:65000

EXPOSE 9091
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh", "/usr/bin/authelia", "--config", "/tmp/configuration.yaml"]

LABEL org.opencontainers.image.source="https://github.com/authelia/authelia/"
