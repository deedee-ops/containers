ARG TARGETPLATFORM
ARG VERSION
FROM f0rc3/gokapi:v${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV GOKAPI_CONFIG_DIR /config
ENV GOKAPI_DATA_DIR /data
ENV GOKAPI_PORT 3000

COPY --from=source /app/gokapi /usr/bin/gokapi

USER 65000:65000
EXPOSE 3000
VOLUME ["/config", "/data", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/usr/bin/gokapi"]

LABEL org.opencontainers.image.source="https://github.com/Forceu/Gokapi"
