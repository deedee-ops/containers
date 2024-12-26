#!/usr/bin/env sh

[ -n "${WEBDAV_HOMES_DIR}" ] && [ ! -d "${WEBDAV_HOMES_DIR}" ] && mkdir -p "${WEBDAV_HOMES_DIR}"
[ -n "${WEBDAV_PUBLIC_DIR}" ] && [ ! -d "${WEBDAV_PUBLIC_DIR}" ] && mkdir -p "${WEBDAV_PUBLIC_DIR}"
[ -n "${WEBDAV_TMP_DIR}" ] && [ ! -d "${WEBDAV_TMP_DIR}" ] && mkdir -p "${WEBDAV_TMP_DIR}"
/usr/local/sbin/php-fpm &
sleep 1

exec "$@"
