ARG VERSION
FROM public.ecr.aws/docker/library/alpine:3.21.4 as builder

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

#hadolint ignore=DL3018
RUN apk add --no-cache bash curl go upx \
 && bash -c 'IFS=/ read -r GOOS GOARCH <<< "${TARGETPLATFORM}" && go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest' \
 && upx --ultra-brute /go/bin/envsubst

#hadolint ignore=DL4006
RUN set -x \
 && curl -OL "https://github.com/ajgon/envdir/releases/download/${ENVDIR_VER}/envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" \
 && tar -xzf "envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" -C /go/bin/ envdir \
 && upx --ultra-brute /go/bin/envdir

ARG VERSION
FROM ghcr.io/home-operations/bazarr:${VERSION}

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN apk --update add --no-cache \
    bind-tools \
    ca-certificates \
    curl \
    git \
    iputils \
    jq \
    netcat-openbsd \
    openssl \
    tini \
    tzdata \
    yq \
 && addgroup -S abc --gid 65000 \
 && adduser -S abc -G abc --uid 65000 \
 && mkdir -p /config \
 && chown -R abc:abc /app /config \
 && chmod -R 775 /app /config \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && rm -rf /tmp/* \
 && sh -c 'mkdir /add-ons && cd /add-ons && git clone https://github.com/KBlixt/subcleaner.git' \
 && chown -R 65000:65000 /add-ons \
 && apk del --purge git

COPY --from=builder /go/bin/envdir /usr/bin/envdir
COPY --from=builder /go/bin/envsubst /usr/bin/envsubst
COPY --chmod=0755 --chown=65000:65000 base-entrypoint.sh /usr/local/bin/base-entrypoint.sh
COPY --chown=65000:65000 _/app/config.yaml.tmpl /app/config.yaml.tmpl
COPY --chown=65000:65000 _/add-ons/subcleaner/regex_profiles/default/polish.conf /add-ons/subcleaner/regex_profiles/default/polish.conf
COPY --chown=65000:65000 _/add-ons/subcleaner/subcleaner.conf /add-ons/subcleaner/subcleaner.conf

USER 65000:65000
VOLUME ["/config", "/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"
