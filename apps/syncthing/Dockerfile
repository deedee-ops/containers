ARG TARGETPLATFORM
ARG VERSION
FROM syncthing/syncthing:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.20.1

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /bin/syncthing /usr/bin/syncthing

ENV STHOMEDIR=/config

USER 65000:65000
EXPOSE 8384 22000/tcp 22000/udp 21027/udp
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/bin/syncthing"]
CMD ["serve"]

LABEL org.opencontainers.image.source="https://github.com/syncthing/syncthing/"
