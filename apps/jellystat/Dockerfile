FROM ghcr.io/deedee-ops/alpine:3.21.4

ARG TARGETPLATFORM
ARG VERSION

WORKDIR /app

#hadolint ignore=DL3018,DL4006
RUN apk add git nodejs npm --no-cache \
 && git clone --depth 1 --branch "$(echo "${VERSION}" | sed 's@latest@unstable@g')" --single-branch https://github.com/CyferShepard/Jellystat . \
 && rm -rf .git \
 && npm install \
 && npm run build \
 && chown -R 65000:65000 /app \
 && apk del --purge git

EXPOSE 3000

USER 65000:65000
VOLUME ["/tmp"]
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD ["npm", "run", "start"]

LABEL org.opencontainers.image.source="https://github.com/CyferShepard/Jellystat"
