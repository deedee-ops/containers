ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/lldap/lldap:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.20.2

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /app /app
COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/entrypoint.sh
RUN ln -s /config/server_key /app/server_key

ENV LDAP_PORT=3890
ENV HTTP_PORT=17170
ENV LLDAP_DATABASE_URL=sqlite:///config/users.db?mode=rwc

USER 65000:65000
EXPOSE ${LDAP_PORT} ${HTTP_PORT}
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/entrypoint.sh", "/app/lldap"]
CMD ["run"]

LABEL org.opencontainers.image.source="https://github.com/lldap/lldap/"
