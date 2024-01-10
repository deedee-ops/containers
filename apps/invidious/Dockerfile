ARG TARGETPLATFORM
ARG VERSION
FROM quay.io/invidious/invidious:latest@sha256:7da41b32475a5619cf0591ca966041f03cc91e7bb02bff15ff8483686b698abf AS source

FROM ghcr.io/deedee-ops/alpine:3.19.0

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source --chown=65000:65000 /invidious /app/

#hadolint ignore=DL3018
RUN apk add --no-cache librsvg postgresql-client ttf-opensans yq \
 && curl -o /app/init-invidious-db.sh https://raw.githubusercontent.com/iv-org/invidious/master/docker/init-invidious-db.sh \
 && sed -i'' "s@--dbname@--host \"\$POSTGRES_HOST\" --port \"\${POSTGRES_PORT:-5432}\" --dbname@g" /app/init-invidious-db.sh \
 && mkdir -p /config \
 && chown -R 65000:65000 /config \
 && mv /app/config/config.yml /config/config.yml \
 && ln -s /config/config.yml /app/config/config.yml

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
USER 65000:65000

EXPOSE 3000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/app/invidious"]

LABEL org.opencontainers.image.source="https://github.com/iv-org/invidious/"
