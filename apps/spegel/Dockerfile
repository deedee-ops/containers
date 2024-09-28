ARG TARGETPLATFORM
ARG VERSION

FROM ghcr.io/deedee-ops/ubuntu:22.04 AS builder

WORKDIR /usr/src

ENV CGO_ENABLED=0

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --yes --no-install-recommends bash build-essential git gnupg2 software-properties-common \
 && add-apt-repository ppa:longsleep/golang-backports -y \
 && apt-get update \
 && apt-get install --yes --no-install-recommends golang-go \
 && git clone --depth 1 --branch v0.0.24 https://github.com/spegel-org/spegel/

WORKDIR /usr/src/spegel

COPY fix-containerd.patch /usr/src/spegel/

RUN patch -p1 < fix-containerd.patch \
 && go build -installsuffix 'static' -o spegel .

FROM gcr.io/distroless/static:nonroot

COPY --from=builder /usr/src/spegel/spegel /app/

WORKDIR /app

#hadolint ignore=DL3002
USER root:root

ENTRYPOINT ["./spegel"]

LABEL org.opencontainers.image.source="https://github.com/spegel-org/spegel/"
