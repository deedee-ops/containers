#!/usr/bin/env sh

if [ -n "${FIREFOXSYNC__POSTGRES_HOST}" ]; then
  export SYNCSERVER_SQLURI="postgresql://${FIREFOXSYNC__POSTGRES_USERNAME}:${FIREFOXSYNC__POSTGRES_PASSWORD}@${FIREFOXSYNC__POSTGRES_HOST}:${FIREFOXSYNC__POSTGRES_PORT:-5432}/${FIREFOXSYNC__POSTGRES_DATABASE}?sslmode=${FIREFOXSYNC__POSTGRES_SSLMODE:-require}"
else
  export SYNCSERVER_SQLURI="${SYNCSERVER_SQLURI:-sqlite:////config/syncserver.db}"
fi

export SYNCSERVER_BATCH_UPLOAD_ENABLED="true"
export SYNCSERVER_FORCE_WSGI_ENVIRON="true"
export SYNCSERVER_PUBLIC_URL="${FIREFOXSYNC__PUBLIC_URL:-http://localhost:3000}"
if [ -n "${FIREFOXSYNC__SECRET_FILE}" ]; then
  export SYNCSERVER_SECRET_FILE="${FIREFOXSYNC__SECRET_FILE}"
else
  if [ -n "${FIREFOXSYNC__SECRET}" ]; then
    echo "${FIREFOXSYNC__SECRET}" > /tmp/firefoxsync-secret
    export SYNCSERVER_SECRET_FILE="/tmp/firefoxsync-secret"
  fi
fi

exec "$@"
