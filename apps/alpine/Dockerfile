ARG VERSION
FROM public.ecr.aws/docker/library/alpine:3.18 as builder

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
ENV ENVDIR_VER=v0.1.0

#hadolint ignore=DL3018
RUN apk add --no-cache bash curl go upx \
 && bash -c 'IFS=/ read -r GOOS GOARCH <<< "${TARGETPLATFORM}" && go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest' \
 && upx --ultra-brute /go/bin/envsubst

#hadolint ignore=DL4006
RUN set -x \
 && curl -OL "https://github.com/ajgon/envdir/releases/download/${ENVDIR_VER}/envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" \
 && tar -xzf "envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" -C /go/bin/ envdir \
 && upx --ultra-brute /go/bin/envdir

FROM public.ecr.aws/docker/library/alpine:${VERSION}

ARG VERSION
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}
ENV UMASK="0002" \
    TZ="Etc/UTC"
WORKDIR /app

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN apk --update add --no-cache \
    bind-tools \
    ca-certificates \
    curl \
    iputils \
    jq \
    openssl \
    tini \
    tzdata \
 && addgroup -S abc --gid 65000 \
 && adduser -S abc -G abc --uid 65000 \
 && mkdir -p /config /data \
 && chown -R abc:abc /app /config /data \
 && chmod -R 775 /app /config /data \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && ln -s /usr/bin/vi   /usr/local/bin/vi \
 && ln -s /usr/bin/vi   /usr/local/bin/vim \
 && rm -rf /tmp/*

VOLUME ["/tmp"]
COPY --from=builder /go/bin/envdir /usr/bin/envdir
COPY --from=builder /go/bin/envsubst /usr/bin/envsubst
COPY --chmod=0755 --chown=65000:65000 base-entrypoint.sh /usr/local/bin/base-entrypoint.sh
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
