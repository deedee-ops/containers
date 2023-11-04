ARG VERSION
FROM public.ecr.aws/docker/library/ubuntu:${VERSION} as builder

ARG VERSION
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT} \
    GOPATH=/go
ENV PATH $GOPATH/bin:$PATH
ENV ENVDIR_VER=v0.1.2

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --no-install-recommends --yes bash ca-certificates curl golang upx \
 && bash -c 'IFS=/ read -r GOOS GOARCH <<< "${TARGETPLATFORM}" && go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest' \
 && upx --ultra-brute /go/bin/envsubst

#hadolint ignore=DL4006
RUN set -x \
 && curl -OL "https://github.com/ajgon/envdir/releases/download/${ENVDIR_VER}/envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" \
 && tar -xzf "envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" -C /go/bin/ envdir \
 && upx --ultra-brute /go/bin/envdir

FROM public.ecr.aws/docker/library/ubuntu:${VERSION}

ARG VERSION
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
ENV DEBIAN_FRONTEND=noninteractive
ENV UMASK="0002" \
    TZ="Etc/UTC"
WORKDIR /app

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
    bash \
    ca-certificates \
    curl \
    dnsutils \
    iputils-ping \
    jq \
    netcat-openbsd \
    openssl \
    tini \
    tzdata \
    vim-tiny \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && groupadd -g 65000 abc \
 && useradd -g abc -u 65000 abc \
 && mkdir -p /config \
 && chown -R abc:abc /app /config \
 && chmod -R 775 /app /config \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && ln -s /usr/bin/vi   /usr/local/bin/vi \
 && ln -s /usr/bin/vi   /usr/local/bin/vim \
 && ln -s /usr/bin/tini /sbin/tini \
 && rm -rf /tmp/*

VOLUME ["/config"]
COPY --from=builder /go/bin/envdir /usr/bin/envdir
COPY --from=builder /go/bin/envsubst /usr/bin/envsubst
COPY --chmod=0755 --chown=65000:65000 base-entrypoint.sh /usr/local/bin/base-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]

CMD ["/bin/bash"]
