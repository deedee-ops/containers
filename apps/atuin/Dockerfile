ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/atuinsh/atuin:${VERSION} as source

FROM ghcr.io/deedee-ops/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV ATUIN_HOST=0.0.0.0
ENV ATUIN_CONFIG_DIR=/config

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=source /usr/local/bin/atuin /usr/bin/atuin

USER 65000:65000
EXPOSE 8888
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/atuin", "server", "start"]

LABEL org.opencontainers.image.source="https://github.com/atuinsh/atuin/"
