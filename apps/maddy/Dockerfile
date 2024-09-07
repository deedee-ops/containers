ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/foxcpp/maddy:${VERSION} as source

FROM ghcr.io/deedee-ops/alpine:3.20.3

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /bin/maddy /usr/bin/maddy
COPY --from=source --chown=65000:65000 /data/maddy.conf /config/maddy.conf
COPY --chown=65000:65000 _/ /
RUN sed -i'' 's@/data/@/config/@g' /config/maddy.conf \
 && echo "state_dir /config" >> /config/maddy.conf

USER 65000:65000
EXPOSE 25 143 465 587 993
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/bin/maddy", "-config", "/config/maddy.conf"]
CMD ["run"]

LABEL org.opencontainers.image.source="https://github.com/foxcpp/maddy/"
