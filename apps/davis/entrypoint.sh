#!/usr/bin/env sh

/usr/local/sbin/php-fpm &
sleep 1

exec "$@"
