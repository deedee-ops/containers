#! /usr/bin/env sh

# @source: https://github.com/itbm/postgresql-backup-s3

set -e

>&2 echo "-----"

if [ "${S3_S3V4:-yes}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ -z "${S3_ACCESS_KEY_ID}" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ -z "${S3_SECRET_ACCESS_KEY}" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "${POSTGRES_DATABASE}" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ -z "${POSTGRES_HOST}" ]; then
  if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ -z "${POSTGRES_USER}" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ -z "${POSTGRES_PASSWORD}" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

if [ -z "${S3_ENDPOINT}" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID="${S3_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${S3_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${S3_REGION:-us-east-1}"

export PGPASSWORD="${POSTGRES_PASSWORD}"
POSTGRES_HOST_OPTS="-h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} ${POSTGRES_EXTRA_OPTS}"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

SRC_FILE=/tmp/dump.sql.gz
DEST_FILE=${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz

if [ "${POSTGRES_DATABASE}" = "all" ]; then
  # shellcheck disable=SC2086
  pg_dumpall ${POSTGRES_HOST_OPTS} | gzip > $SRC_FILE
else
  # shellcheck disable=SC2086
  pg_dump ${POSTGRES_HOST_OPTS} "${POSTGRES_DATABASE}" | gzip > $SRC_FILE
fi


if [ -n "${ENCRYPTION_PASSWORD}" ]; then
  >&2 echo "Encrypting ${SRC_FILE}"
  if ! openssl enc -pbkdf2 -aes-256-cbc -in $SRC_FILE -out ${SRC_FILE}.enc -k "${ENCRYPTION_PASSWORD}"; then
    >&2 echo "Error encrypting ${SRC_FILE}"
  fi
  rm $SRC_FILE
  SRC_FILE="${SRC_FILE}.enc"
  DEST_FILE="${DEST_FILE}.enc"
fi

echo "Uploading dump to $S3_BUCKET"

# shellcheck disable=SC2086
cat $SRC_FILE | aws ${AWS_ARGS} s3 cp - "s3://${S3_BUCKET}/${S3_PREFIX}/${DEST_FILE}" || exit 2

if [ -n "${DELETE_OLDER_THAN}" ]; then
  >&2 echo "Checking for files older than ${DELETE_OLDER_THAN}"
  # shellcheck disable=SC2086
  aws ${AWS_ARGS} s3 ls "s3://${S3_BUCKET}/${S3_PREFIX}/" | grep " PRE " -v | while read -r line;
    do
      fileName=$(echo "$line"|awk "{'print \$4'}")
      created=$(echo "$line"|awk "{'print \$1\" \"\$2'}")
      created=$(date -d "$created" +%s)
      older_than=$(date -d "$DELETE_OLDER_THAN" +%s)
      if [ "$created" -lt "$older_than" ]
        then
          if [ "$fileName" != "" ]
            then
              >&2 echo "DELETING ${fileName}"
              # shellcheck disable=SC2086
              aws ${AWS_ARGS} s3 rm "s3://${S3_BUCKET}/${S3_PREFIX}/${fileName}"
          fi
      else
          >&2 echo "${fileName} not older than ${DELETE_OLDER_THAN}"
      fi
    done;
fi

echo "SQL backup finished"

>&2 echo "-----"
