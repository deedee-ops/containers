#!/usr/bin/env bash

mkdir -p /tmp/html /tmp/apache2 /config/upload
cp -rT /var/www/html/ /tmp/html/
rm -rf /tmp/html/storage/upload
ln -s /config/upload /tmp/html/storage/upload

cd "${FIREFLY_III_PATH}" || exit 1

exec "$@"
