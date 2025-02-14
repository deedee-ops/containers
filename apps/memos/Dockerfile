ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/usememos/memos:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
COPY --from=source /usr/local/memos/memos /usr/bin/memos

ENV MEMOS_MODE="prod"
ENV MEMOS_PORT="5230"

USER 65000:65000
EXPOSE 5230
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/memos"]

LABEL org.opencontainers.image.source="https://github.com/usememos/memos/"
