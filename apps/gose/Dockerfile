ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/stv0g/gose:v${VERSION} AS source

FROM ghcr.io/deedee-ops/alpine:3.21.1

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /gose /usr/bin/gose

ENV GIN_MODE=release
ENV GOSE_LISTEN=":8080"

USER 65000:65000
EXPOSE 8080
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/usr/bin/gose"]

LABEL org.opencontainers.image.source="https://github.com/stv0g/gose/"
