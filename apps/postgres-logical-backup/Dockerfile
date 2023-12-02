FROM ghcr.io/deedee-ops/ubuntu:22.04

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --yes --no-install-recommends gnupg lsb-release unzip \
 && echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && /bin/sh -c 'curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -' \
 && apt-get update \
 && psqlver="$(/bin/sh -c "echo '${VERSION}' | awk -F. '{ print \$1 }'")" \
 && apt-get install --yes --no-install-recommends "postgresql-client-${psqlver}" \
 && sh -c 'cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf aws' \
 && apt-get remove --purge --yes lsb-release unzip \
 && apt-get clean -q -y \
 && rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh

ENV HOME=/tmp
USER 65000:65000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/itbm/postgresql-backup-s3"
