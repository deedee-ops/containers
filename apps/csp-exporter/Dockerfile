ARG VERSION
FROM public.ecr.aws/docker/library/golang:1.24-alpine as builder

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

WORKDIR /app

#hadolint ignore=DL3018
RUN apk add --no-cache --update bash git \
 && git clone --branch "v${VERSION}" https://git.benburwell.com/csp_exporter . \
 && bash -c 'IFS=/ read -r GOOS GOARCH <<< "${TARGETPLATFORM}" && go build -o csp_exporter main.go'

FROM ghcr.io/deedee-ops/alpine:3.21.2

ENV COLLECTOR_BIND_ADDR=0.0.0.0:8000
ENV PROM_BIND_ADDR=0.0.0.0:9477

COPY --from=builder /app/csp_exporter /usr/bin/csp_exporter

USER 65000:65000

EXPOSE 3000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["csp_exporter"]

LABEL org.opencontainers.image.source="https://git.benburwell.com/csp_exporter"
