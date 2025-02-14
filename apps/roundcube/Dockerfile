FROM ghcr.io/deedee-ops/alpine:3.21.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY lighttpd.conf /tmp/lighttpd.conf
COPY 99_roundcube.ini /tmp/99_roundcube.ini

# hadolint ignore=DL3018
RUN curl -O -L "https://github.com/roundcube/roundcubemail/releases/download/${VERSION}/roundcubemail-${VERSION}.tar.gz" \
 && tar --strip-components=1 -xzf "roundcubemail-${VERSION}.tar.gz" \
 && rm -rf "roundcubemail-${VERSION}.tar.gz" \
 && jq '.repositories[.repositories|length] |= .+ {"type": "git", "url": "https://github.com/dapphp/keyboard_shortcuts.git"} | .require += {"dapphp/keyboard_shortcuts": ">= 3.0", "kolab/net_ldap3": ">=0"}' /app/composer.json-dist > /app/composer.json \
 && apk add --no-cache --virtual .build-deps composer git php-pear \
 && apk add --no-cache \
            fcgi \
            lighttpd \
            php-cgi \
            php-ctype \
            php-curl \
            php-dom \
            php-exif \
            php-fileinfo \
            php-gd \
            php-iconv \
            php-intl \
            php-ldap \
            php-mbstring \
            php-pdo \
            php-pdo_mysql \
            php-pdo_pgsql \
            php-pdo_sqlite \
            php-session \
            php-tokenizer \
            php-xml \
            php-xmlwriter \
            php-zip \
 && apk add --no-cache "$(basename "$(ls -d /etc/php*)")-pecl-imagick" --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
 && composer install --no-ansi --no-dev --no-interaction --no-progress --optimize-autoloader \
 && bin/install-jsdeps.sh \
 && mv /tmp/lighttpd.conf /etc/lighttpd/lighttpd.conf \
 && mv /tmp/99_roundcube.ini "$(ls -d /etc/php*)/conf.d/99_roundcube.ini" \
 && mkdir -p /run/lighttpd/ \
 && mv /app/config/* /config \
 && rm -rf /app/config \
 && ln -s /config /app/config \
 && chown -R abc:abc /run/lighttpd/ /app /config \
 && chmod 777 /etc/php*/conf.d/ \
 && echo 'error_log = /proc/self/fd/2' > "$(ls -d /etc/php*)/conf.d/05_error_log.ini" \
 && echo 'catch_workers_output = yes' >> "$(ls -d /etc/php*)/conf.d/05_error_log.ini" \
 && apk del .build-deps

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

USER 65000:65000
EXPOSE 3000
VOLUME ["/run/lighttpd", "/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

LABEL org.opencontainers.image.source="https://github.com/roundcube/roundcubemail/"
