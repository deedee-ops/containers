ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/deedee-ops/alpine:3.21.1 AS source

WORKDIR /app

#hadolint ignore=DL3018
RUN apk --update add --no-cache alpine-sdk curl git \
 && mkdir -p /etc/cron.d && chown -R 1001 /etc/cron.d \
 && git clone https://github.com/eltorio/dcron.git . \
 && make CRONTAB_GROUP=abc CRONTABS=/var/spool/cron/crontabs

FROM php:8.2-fpm-alpine

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
ENV VERSION="${VERSION}" \
    UMASK="0002" \
    TZ="Etc/UTC" \
    XDG_CONFIG_HOME="/tmp/config" \
    XDG_DATA_HOME="/tmp/data"

WORKDIR /app

#hadolint ignore=DL3018,SC2086
RUN apk --update add --no-cache \
                 autoconf \
                 bind-tools \
                 ca-certificates \
                 caddy \
                 curl \
                 freetype \
                 freetype-dev \
                 icu-data-full \
                 icu-dev \
                 imagemagick \
                 imagemagick-dev \
                 iputils \
                 jq \
                 libgomp \
                 libjpeg-turbo \
                 libjpeg-turbo-dev \
                 libpng \
                 libpng-dev \
                 libwebp-dev \
                 libzip-dev \
                 netcat-openbsd \
                 openssl \
                 sqlite \
                 sqlite-dev \
                 tini \
                 tzdata \
 && docker-php-ext-install pdo pdo_sqlite calendar \
 && docker-php-ext-enable pdo pdo_sqlite \
 && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install -j "$(nproc)" gd intl zip \
 && apk add --no-cache --virtual .build-deps git ${PHPIZE_DEPS%,*} \
 && pecl install imagick \
 && docker-php-ext-enable imagick \
 && git clone --branch "v${VERSION}" https://github.com/ellite/Wallos . \
 && rm -rf .git \
 && apk del .build-deps \
 && mkdir -p /var/log/cron \
 && sed -i 's/listen = /;listen = /' /usr/local/etc/php-fpm.d/www.conf \
 && sed -i 's/listen = 9000/listen = \/tmp\/php-fpm.sock/' /usr/local/etc/php-fpm.d/zz-docker.conf \
 && echo 'pm.max_children = 15' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
 && echo 'pm.max_requests = 500' >> /usr/local/etc/php-fpm.d/zz-docker.conf \
 && mkdir -p /config /data/logos \
 && rm -rf /app/db \
 && ln -fs /config /app/db \
 && ln -fs /data/logos /app/images/uploads/logos \
 && addgroup -S abc --gid 65000 \
 && adduser -S abc -G abc --uid 65000 \
 && chown -R abc:abc /app /config /data \
 && chmod 775 /app /config /data \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && ln -s /usr/bin/vi /usr/local/bin/vi \
 && ln -s /usr/bin/vi /usr/local/bin/vim \
 && rm /usr/sbin/crond \
 && mkdir -p /etc/cron.d \
 && sed -i 's@/var/www/html@/app@g' cronjobs \
 && dos2unix cronjobs \
 && rm -rf /var/spool/cron/crontabs/root /etc/crontabs/root \
 && /usr/bin/crontab -u abc cronjobs \
 && chown -R 65000 /etc/cron.d /var/log/cron /etc/crontabs \
 && rm -rf /tmp/* \
 && mkdir -p "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}" \
 && chown -R 65000:65000 "${XDG_CONFIG_HOME}" "${XDG_DATA_HOME}"

COPY --from=source /usr/bin/envdir /usr/bin/envdir
COPY --from=source /usr/bin/envsubst /usr/bin/envsubst
COPY --from=source /usr/local/bin/base-entrypoint.sh /usr/local/bin/base-entrypoint.sh
COPY --from=source /app/crond /usr/sbin/crond
COPY --chmod=0644 --chown=65000:65000 _/etc/caddy/Caddyfile /etc/caddy/Caddyfile
COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

USER 65000:65000
EXPOSE 9000
VOLUME ["/config", "/data", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/caddy", "run", "-c", "/etc/caddy/Caddyfile"]

LABEL org.opencontainers.image.source="https://github.com/ellite/Wallos/"
