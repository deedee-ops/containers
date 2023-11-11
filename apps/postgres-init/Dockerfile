FROM ghcr.io/ajgon/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --yes --no-install-recommends gnupg lsb-release \
 && echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && /bin/sh -c 'curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -' \
 && apt-get update \
 && psqlver="$(/bin/sh -c "echo '${VERSION}' | awk -F. '{ print \$1 }'")" \
 && apt-get install --yes --no-install-recommends "postgresql-client-${psqlver}" \
 && apt-get remove --purge --yes lsb-release \
 && apt-get clean -q -y \
 && rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

ENV HOME=/tmp
USER 65000:65000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/postgres/postgres"
