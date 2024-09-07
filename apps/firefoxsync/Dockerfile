FROM ghcr.io/deedee-ops/alpine:3.20.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN case "${TARGETPLATFORM}" in \
        'linux/amd64') export ARCH='x86_64' ;; \
        'linux/arm64') export ARCH='aarch64' ;; \
    esac \
 && set -x \
 && wget -q -O /tmp/python2.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/community/${ARCH}/python2-2.7.18-r4.apk" \
 && wget -q -O /tmp/python2-dev.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/community/${ARCH}/python2-dev-2.7.18-r4.apk" \
 && wget -q -O /tmp/libcrypto11.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/main/${ARCH}/libcrypto1.1-1.1.1w-r1.apk" \
 && wget -q -O /tmp/libssl11.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/main/${ARCH}/libssl1.1-1.1.1w-r1.apk" \
 && apk del --purge openssl \
 && apk add /tmp/libcrypto11.apk /tmp/libssl11.apk /tmp/python2.apk libpq libstdc++ --allow-untrusted --no-cache \
 && apk add /tmp/python2-dev.apk build-base gcc git libffi-dev musl-dev --allow-untrusted --no-cache --virtual .build-deps \
 && /bin/ash -o pipefail -c 'curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python' \
 && wget -q -O /tmp/openssl11.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/main/${ARCH}/openssl-1.1.1w-r1.apk" \
 && wget -q -O /tmp/openssl11-dev.apk "https://dl-cdn.alpinelinux.org/alpine/v3.15/main/${ARCH}/openssl-dev-1.1.1w-r1.apk" \
 && apk add /tmp/openssl11.apk /tmp/openssl11-dev.apk --no-cache \
 && pip install --no-cache-dir cryptography==2.6.1 \
 && apk del --purge openssl openssl-dev \
 && apk add mariadb-dev postgresql-dev --no-cache --virtual .extra-deps \
 && git clone https://github.com/mozilla-services/syncserver \
 && sed -E -i'' 's@(config.add_view.*$)@\1\n    config.add_route("healthcheck", "/-/healthz")\n    config.add_view(itworks, route_name="healthcheck")@g' /app/syncserver/syncserver/__init__.py \
 && sed -i'' 's/^google-cloud-spanner.*/google-cloud-spanner==1.9.0/g' syncserver/requirements.txt \
 && echo 'grpcio==1.26.0' >> syncserver/requirements.txt \
 && pip install --no-cache-dir -r syncserver/requirements.txt \
 && sh -c 'cd syncserver && python setup.py develop' \
 && apk del --purge .build-deps .extra-deps \
 && pip uninstall pip --yes \
 && rm -rf /tmp/*.apk

USER 65000:65000
COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]
VOLUME ["/config", "/tmp"]
CMD ["/usr/bin/gunicorn", "--bind", "0.0.0.0:3000", "--forwarded-allow-ips=\"*\"", "syncserver.wsgi_app"]

LABEL org.opencontainers.image.source="https://github.com/mozilla-services/syncserver/"
