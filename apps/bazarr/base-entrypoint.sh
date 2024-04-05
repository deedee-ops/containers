#!/usr/bin/envdir sh
# shellcheck shell=dash

set -e

if [ -n "${DEBUG_OS}" ]; then
  set -x
fi

# STEP 1:
# Scans the environment variables for those with the suffix _FILE
# When located, checks the file exists, and exports the contents
# of the file as the same name, minus the suffix
# This allows the use of Docker secrets or mounted files
# to fill in any of the settings configurable via environment
# variables

if [ -z "${SKIP_FILE_SECRETS_EXPANSION}" ]; then
  for line in $(printenv)
  do
    env_name=${line%%=*}
    if [ -n "${env_name}" ] && [ -z "${env_name##*"_FILE"*}" ]; then # checks if env_name ends with _FILE
      env_value=${line#*=}

      if [ -f "${env_value}" ]; then
        non_file_env_name=${env_name%"_FILE"}
        echo "Setting ${non_file_env_name} from file"

        val="$(head -n 1 "${env_value}")"
        export "${non_file_env_name}"="${val}"
      else
        echo "File ${env_value} referenced by ${env_name} doesn't exist"
      fi
    fi
  done
fi

if [ ! -f /config/config/config.yaml ]; then
  mkdir -p /config/config || true
  envsubst < /app/config.yaml.tmpl > /config/config/config.yaml
fi

if [ -n "${BAZARR__ANALYTICS_ENABLED}" ]; then
  yq -i ".analytics.enabled = ${BAZARR__ANALYTICS_ENABLED}" /config/config/config.yaml
fi

if [ -n "${BAZARR__API_KEY}" ]; then
  yq -i ".auth.apikey = \"${BAZARR__API_KEY}\"" /config/config/config.yaml
fi

if [ -n "${BAZARR__POSTGRES_DB}" ]; then
  yq -i ".postgresql.database = \"${BAZARR__POSTGRES_DB}\"" /config/config/config.yaml
fi

if [ -n "${BAZARR__POSTGRES_ENABLED}" ]; then
  yq -i ".postgresql.enabled = ${BAZARR__POSTGRES_ENABLED}" /config/config/config.yaml
fi
if [ -n "${BAZARR__POSTGRES_HOST}" ]; then
  yq -i ".postgresql.host = \"${BAZARR__POSTGRES_HOST}\"" /config/config/config.yaml
fi
if [ -n "${BAZARR__POSTGRES_PASSWORD}" ]; then
  yq -i ".postgresql.password = \"${BAZARR__POSTGRES_PASSWORD}\"" /config/config/config.yaml
fi
if [ -n "${BAZARR__POSTGRES_PORT}" ]; then
  yq -i ".postgresql.port = \"${BAZARR__POSTGRES_PORT}\"" /config/config/config.yaml
fi
if [ -n "${BAZARR__POSTGRES_USERNAME}" ]; then
  yq -i ".postgresql.username = \"${BAZARR__POSTGRES_USERNAME}\"" /config/config/config.yaml
fi

exec "$@"
