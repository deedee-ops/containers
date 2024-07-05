ARG VERSION
FROM public.ecr.aws/docker/library/ubuntu:24.04 as builder

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
 && apt-get install --no-install-recommends --yes bash ca-certificates curl golang upx

#hadolint ignore=DL4006
RUN set -x \
 && mkdir -p /go/bin \
 && curl -OL "https://github.com/ajgon/envdir/releases/download/${ENVDIR_VER}/envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" \
 && tar -xzf "envdir_$(uname -s)_$(uname -m | sed 's@aarch64@arm64@g').tar.gz" -C /go/bin/ envdir \
 && upx --ultra-brute /go/bin/envdir

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL
FROM ayufan/proxmox-backup-server:v${VERSION}

#hadolint ignore=DL3005,DL3008,DL3009
RUN sed -i'' 's@: main@: main contrib@g' /etc/apt/sources.list.d/debian.sources \
 && sed -i'' 's@^@# @g' /etc/apt/sources.list.d/pbs-enterprise.list \
 && echo "deb http://download.proxmox.com/debian/pbs $(awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release) pbs-no-subscription" > /etc/apt/sources.list.d/pbs-install-repo.list \
 && echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data\.status.*{/{s/\!//;s/active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" >/etc/apt/apt.conf.d/no-nag-script \
 && curl https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -o /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg \
 && curl https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -o /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg \
 && apt-get update \
 && apt-get --reinstall --no-install-recommends --yes install proxmox-widget-toolkit \
 && apt-get upgrade --yes \
 && apt-get dist-upgrade --yes \
 && apt-get clean \
 && apt-get autoremove --purge --yes

COPY --from=builder /go/bin/envdir /usr/bin/envdir
COPY --chmod=0755 base-entrypoint.sh /usr/local/bin/base-entrypoint.sh

EXPOSE 8007
VOLUME ["/run", "/etc/proxmox-backup", "/var/log/proxmox-backup", "/var/lib/proxmox-backup"]
ENTRYPOINT ["/usr/local/bin/base-entrypoint.sh"]
CMD ["runsvdir", "/runit"]

LABEL org.opencontainers.image.source="https://github.com/ayufan/pve-backup-server-dockerfiles/"
