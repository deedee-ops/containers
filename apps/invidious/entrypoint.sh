#!/usr/bin/env sh

export POSTGRES_HOST="${POSTGRES_HOST:-$(yq '.db.host // ""' < /config/config.yml)}"
export POSTGRES_PORT="${POSTGRES_PORT:-$(yq '.db.port //""' < /config/config.yml)}"
export POSTGRES_USER="${POSTGRES_USER:-$(yq '.db.user // ""' < /config/config.yml)}"
export POSTGRES_DB="${POSTGRES_DB:-$(yq '.db.dbname // ""' < /config/config.yml)}"
export PGPASSWORD="${POSTGRES_PASS:-$(yq '.db.password //""' < /config/config.yml)}"

sh /app/init-invidious-db.sh

exec "$@"
