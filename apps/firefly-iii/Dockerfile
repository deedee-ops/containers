ARG VERSION
FROM public.ecr.aws/docker/library/ubuntu:22.04 as builder

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


ARG VERSION
FROM fireflyiii/core:version-${VERSION}

ENV FIREFLY_III_PATH=/var/www/firefly

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
 && rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/share/man /usr/local/man /usr/local/share/man \
 && usermod -u 65000 www-data \
 && groupmod -g 65000 www-data \
 && chown -R 65000:65000 /var/www/html \
 && sed -i'' 's@/var/www/html@/var/www/firefly@g' /etc/apache2/sites-available/default-ssl.conf \
 && sed -i'' 's@/var/www/html@/var/www/firefly@g' /etc/apache2/sites-available/000-default.conf \
 && ln -s /tmp/html /var/www/firefly \
 && rm -rf /var/run/apache2 \
 && ln -s /tmp/apache2 /var/run/apache2 \
 && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
 && ln -s /usr/bin/vi   /usr/local/bin/vi \
 && ln -s /usr/bin/vi   /usr/local/bin/vim \
 && ln -s /usr/bin/tini /sbin/tini

COPY --from=builder /go/bin/envdir /usr/bin/envdir
COPY --from=builder /go/bin/envsubst /usr/bin/envsubst
COPY --chmod=0755 --chown=65000:65000 entrypoint.sh /usr/local/bin/mid-entrypoint.sh
COPY --chmod=0755 --chown=65000:65000 base-entrypoint.sh /usr/local/bin/base-entrypoint.sh

USER 65000:65000
EXPOSE 8080
VOLUME ["/tmp"]
ENTRYPOINT ["/usr/local/bin/base-entrypoint.sh", "/usr/local/bin/mid-entrypoint.sh", "/usr/local/bin/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/firefly-iii/firefly-iii/"
