ARG TARGETPLATFORM
ARG VERSION
FROM ghcr.io/deedee-ops/alpine:3.21.4

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

#hadolint ignore=DL3018
RUN apk add --no-cache powertop \
    && rm -rf /tmp/*

VOLUME ["/tmp"]
CMD ["/bin/sh", "-c", "powertop --auto-tune && sleep infinity"]
