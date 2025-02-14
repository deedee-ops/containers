ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/navidrome/navidrome:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV ND_DATAFOLDER=/config \
    ND_LOGLEVEL=info \
    ND_MUSICFOLDER=/data \
    ND_PORT=3000 \
    ND_SCANINTERVAL=1m \
    ND_SESSIONTIMEOUT=30m \
    ND_TRANSCODINGCACHESIZE=100MB

#hadolint ignore=DL3018
RUN apk --no-cache add ffmpeg taglib

COPY --from=source /app/navidrome /usr/bin/navidrome
USER 65000:65000

EXPOSE 3000
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/usr/bin/navidrome", "--datafolder", "/config", "--musicfolder", "/data"]

LABEL org.opencontainers.image.source="https://github.com/navidrome/navidrome/"
