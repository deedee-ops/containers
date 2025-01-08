ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/muety/wakapi:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.21.2

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source --chown=65000:65000 /app /app

# hadolint ignore=DL3018
RUN apk add --no-cache bash

USER 65000:65000
EXPOSE 3000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/app/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/muety/wakapi/"
