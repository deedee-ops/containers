#!/usr/bin/env sh

if [ -n "${MEMOS__POSTGRES_HOST}" ]; then
  export MEMOS_DRIVER="postgres"
  export MEMOS_DSN="postgresql://${MEMOS__POSTGRES_USERNAME}:${MEMOS__POSTGRES_PASSWORD}@${MEMOS__POSTGRES_HOST}:${MEMOS__POSTGRES_PORT:-5432}/${MEMOS__POSTGRES_DATABASE}?sslmode=${MEMOS__POSTGRES_SSLMODE:-require}"
fi

exec "$@"
