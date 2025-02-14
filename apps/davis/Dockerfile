ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/deedee-ops/alpine:3.21.3 AS source

FROM ghcr.io/tchapi/davis:${VERSION}

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

ENV APP_ENV="prod" \
    DATABASE_DRIVER="sqlite" \
    DATABASE_URL="sqlite:////config/davis-database.db" \
    LOG_FILE_PATH="/tmp/davis-php.log" \
    WEBDAV_HOMES_DIR="" \
    WEBDAV_PUBLIC_DIR="/data" \
    WEBDAV_TMP_DIR="/tmp/webdav" \
    UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app

#hadolint ignore=DL3018
RUN apk --update add --no-cache \
                 bind-tools \
                 ca-certificates \
                 caddy \
                 curl \
                 iputils \
                 jq \
                 netcat-openbsd \
                 openssl \
                 tini \
                 tzdata \
 && mkdir -p /config /data \
 && mv /var/www/davis/* /app \
 && mv /var/www/davis/.env* /app \
 && addgroup -S abc --gid 65000 \
 && adduser -S abc -G abc --uid 65000 \
 && chown -R abc:abc /app /config /data \
 && chmod 775 /app /config /data \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && ln -s /usr/bin/vi /usr/local/bin/vi \
 && ln -s /usr/bin/vi /usr/local/bin/vim \
 && sed -i 's/listen = /;listen = /' /usr/local/etc/php-fpm.d/www.conf \
 && sed -i 's/listen = 9000/listen = \/tmp\/php-fpm.sock/' /usr/local/etc/php-fpm.d/zz-docker.conf \
 && sed -i 's/HEADER_X_FORWARDED_ALL/HEADER_X_FORWARDED_FOR/g' /app/public/index.php

COPY --from=source /usr/bin/envdir /usr/bin/envdir
COPY --from=source /usr/bin/envsubst /usr/bin/envsubst
COPY --from=source /usr/local/bin/base-entrypoint.sh /usr/local/bin/base-entrypoint.sh
COPY --chmod=0644 --chown=65000:65000 _/etc/caddy/Caddyfile /etc/caddy/Caddyfile
COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

USER 65000:65000
EXPOSE 9000
VOLUME ["/config", "/data", "/tmp", "/app/var/cache", "/app/vendor/doctrine/cache", "/app/vendor/psr/cache", "/app/vendor/symfony/cache"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/caddy", "run", "-c", "/etc/caddy/Caddyfile"]

LABEL org.opencontainers.image.source="https://github.com/tchapi/davis/"
