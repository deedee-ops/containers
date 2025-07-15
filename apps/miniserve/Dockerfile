ARG TARGETPLATFORM
ARG VERSION
FROM svenstaro/miniserve:${VERSION}-alpine as source

FROM ghcr.io/deedee-ops/alpine:3.21.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /app/miniserve /usr/bin/miniserve

USER 65000:65000
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
VOLUME ["/data", "/tmp"]
CMD ["/usr/bin/miniserve", "/data"]

LABEL org.opencontainers.image.source="https://github.com/svenstaro/miniserve"
