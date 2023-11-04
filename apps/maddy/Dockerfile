ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/foxcpp/maddy:${VERSION} as source

FROM ghcr.io/ajgon/alpine:3.18.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /bin/maddy /usr/bin/maddy
COPY --from=source /data/maddy.conf /data/maddy.conf
COPY --chown=65000:65000 _/ /

USER 65000:65000
EXPOSE 25 143 465 587 993
VOLUME ["/data", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/bin/maddy", "-config", "/data/maddy.conf"]
CMD ["run"]

LABEL org.opencontainers.image.source="https://github.com/foxcpp/maddy/"
