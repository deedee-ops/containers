ARG TARGETPLATFORM
ARG VERSION

FROM ghcr.io/deedee-ops/ubuntu:22.04 AS builder

WORKDIR /usr/src

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --yes --no-install-recommends bash build-essential git gnupg2 software-properties-common \
 && add-apt-repository ppa:longsleep/golang-backports -y \
 && apt-get update \
 && apt-get install --yes --no-install-recommends golang-go \
 && git clone --depth 1 --branch release-3.16 https://github.com/helm/helm

WORKDIR /usr/src/helm

COPY nullify-subchart-values.patch /usr/src/helm/

RUN patch -p1 < nullify-subchart-values.patch \
 && make

FROM quay.io/argoproj/argocd:v${VERSION}

COPY --chmod=0755 --chown=0:0 --from=builder /usr/src/helm/bin/helm /usr/local/bin/helm

ENTRYPOINT ["/usr/bin/tini", "--"]

LABEL org.opencontainers.image.source="https://github.com/argoproj/argo-cd/"
