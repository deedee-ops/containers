ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/bitmagnet-io/bitmagnet:v${VERSION} AS source

FROM ghcr.io/deedee-ops/alpine:3.21.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV HOME=/config

#hadolint ignore=DL3018
RUN apk --no-cache add curl iproute2-ss

COPY --from=source /usr/local/bin/bitmagnet /usr/bin/bitmagnet

USER 65000:65000
WORKDIR /config
EXPOSE 3333
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/usr/bin/bitmagnet", "worker", "run", "--all"]

LABEL org.opencontainers.image.source="https://github.com/bitmagnet-io/bitmagnet/"
