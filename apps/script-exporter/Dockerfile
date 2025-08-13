ARG TARGETPLATFORM
ARG VERSION
FROM ricoberger/script_exporter:v${VERSION} as source
FROM docker.io/bitnami/kubectl:1.33.4 as kubectl

FROM ghcr.io/deedee-ops/alpine:3.21.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

COPY --from=source /bin/script_exporter /usr/bin/script_exporter
COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/bin/kubectl

RUN touch /config/config.yaml

USER 65000:65000
EXPOSE 9469
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh", "/usr/bin/script_exporter"]
CMD ["-config.file", "/config/config.yaml"]

LABEL org.opencontainers.image.source="https://github.com/ricoberger/script_exporter/"
