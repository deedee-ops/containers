#!/usr/bin/env sh

if [ -z "${ENABLE_INSTALLER}" ]; then
  rm -rf /app/installer
fi

exec "$@"
