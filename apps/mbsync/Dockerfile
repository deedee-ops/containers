# alpine mbsync is bugged
FROM ghcr.io/deedee-ops/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

# hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --yes --no-install-recommends isync \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/share/man /usr/local/man /usr/local/share/man

USER 65000:65000
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/usr/local/bin/base-entrypoint.sh", "/usr/bin/mbsync", "-c", "/config/mbsyncrc"]
CMD ["-a"]
