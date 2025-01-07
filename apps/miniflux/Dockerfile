ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/miniflux/miniflux:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.1

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV LISTEN_ADDR 0.0.0.0:3000

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=source /usr/bin/miniflux /usr/bin/miniflux

USER 65000:65000
EXPOSE 3000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/miniflux"]

LABEL org.opencontainers.image.source="https://github.com/miniflux/v2/"
