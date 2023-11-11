#! /usr/bin/env ash
# shellcheck shell=dash

if [ -n "${LLDAP_DATABASE_DRIVER}" ] ||
   [ -n "${LLDAP_DATABASE_USERNAME}" ] ||
   [ -n "${LLDAP_DATABASE_PASSWORD}" ] ||
   [ -n "${LLDAP_DATABASE_HOST}" ] ||
   [ -n "${LLDAP_DATABASE_DBNAME}" ]; then

  if [ -z "${LLDAP_DATABASE_DRIVER}" ] ||
     [ -z "${LLDAP_DATABASE_USERNAME}" ] ||
     [ -z "${LLDAP_DATABASE_PASSWORD}" ] ||
     [ -z "${LLDAP_DATABASE_HOST}" ] ||
     [ -z "${LLDAP_DATABASE_DBNAME}" ]; then

    printf "\e[1;32m%-6s\e[m\n" "Invalid configuration - missing a required environment variable"
    [ -z "${LLDAP_DATABASE_DRIVER}" ]   && printf "\e[1;32m%-6s\e[m\n" "LLDAP_DATABASE_DRIVER: unset"
    [ -z "${LLDAP_DATABASE_USERNAME}" ] && printf "\e[1;32m%-6s\e[m\n" "LLDAP_DATABASE_USERNAME: unset"
    [ -z "${LLDAP_DATABASE_PASSWORD}" ] && printf "\e[1;32m%-6s\e[m\n" "LLDAP_DATABASE_PASSWORD: unset"
    [ -z "${LLDAP_DATABASE_HOST}" ]     && printf "\e[1;32m%-6s\e[m\n" "LLDAP_DATABASE_HOST: unset"
    [ -z "${LLDAP_DATABASE_DBNAME}" ]   && printf "\e[1;32m%-6s\e[m\n" "LLDAP_DATABASE_DBNAME: unset"
    exit 1

  fi

  export LLDAP_DATABASE_URL="${LLDAP_DATABASE_DRIVER}://${LLDAP_DATABASE_USERNAME}:${LLDAP_DATABASE_PASSWORD}@${LLDAP_DATABASE_HOST}/${LLDAP_DATABASE_DBNAME}"

fi

exec "$@"
