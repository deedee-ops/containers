ARG VERSION
FROM ghcr.io/deedee-ops/ubuntu:22.04 as builder

ARG VERSION
ENV NEAREST_TIKA_SERVER_URL="https://dlcdn.apache.org/tika/${VERSION}/tika-server-standard-${VERSION}.jar" \
    ARCHIVE_TIKA_SERVER_URL="https://archive.apache.org/dist/tika/${VERSION}/tika-server-standard-${VERSION}.jar" \
    BACKUP_TIKA_SERVER_URL="https://downloads.apache.org/tika/${VERSION}/tika-server-standard-${VERSION}.jar" \
    DEFAULT_TIKA_SERVER_ASC_URL="https://downloads.apache.org/tika/${VERSION}/tika-server-standard-${VERSION}.jar.asc" \
    ARCHIVE_TIKA_SERVER_ASC_URL="https://archive.apache.org/dist/tika/${VERSION}/tika-server-standard-${VERSION}.jar.asc"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
#hadolint ignore=DL3008
RUN set -x && apt-get update \
 && apt-get -y install gnupg2 --no-install-recommends \
 && curl -sL https://downloads.apache.org/tika/KEYS | gpg --import \
 && curl -sL "${NEAREST_TIKA_SERVER_URL}" -o "/tika-server-standard-${VERSION}.jar" || echo "$?" || ls /tika* || rm "/tika-server-standard-${VERSION}.jar" \
 && sh -c "[ -f /tika-server-standard-${VERSION}.jar ]" || curl -sL "${ARCHIVE_TIKA_SERVER_URL}" -o "/tika-server-standard-${VERSION}.jar" || ls /tika* ||  rm "/tika-server-standard-${VERSION}.jar" \
 && sh -c "[ -f /tika-server-standard-${VERSION}.jar ]" || curl -sL "${BACKUP_TIKA_SERVER_URL}" -o "/tika-server-standard-${VERSION}.jar" || ls /tika* || rm "/tika-server-standard-${VERSION}.jar" \
 && sh -c "[ -f /tika-server-standard-${VERSION}.jar ]" || exit 1 \
 && curl -sL "${DEFAULT_TIKA_SERVER_ASC_URL}" -o "/tika-server-standard-${VERSION}.jar.asc" || rm "/tika-server-standard-${VERSION}.jar.asc" \
 && sh -c "[ -f /tika-server-standard-${VERSION}.jar.asc ]" || curl -sL "${ARCHIVE_TIKA_SERVER_ASC_URL}" -o "/tika-server-standard-${VERSION}.jar.asc" || rm "/tika-server-standard-${VERSION}.jar.asc" \
 && sh -c "[ -f /tika-server-standard-${VERSION}.jar.asc ]" || exit 1 \
 && gpg --verify "/tika-server-standard-${VERSION}.jar.asc" "/tika-server-standard-${VERSION}.jar"

FROM ghcr.io/deedee-ops/ubuntu:22.04

ARG JRE='openjdk-17-jre-headless'
ARG VERSION
ENV VERSION="${VERSION}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
#hadolint ignore=DL3008
RUN set -eux \
 && apt-get update \
 && apt-get install --yes --no-install-recommends gnupg2 software-properties-common \
 && add-apt-repository -y ppa:alex-p/tesseract-ocr5 \
 && apt-get update \
 && apt-get install --yes --no-install-recommends $JRE \
    gdal-bin \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-pol \
 && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
 && apt-get install --yes --no-install-recommends \
    xfonts-utils \
    fonts-freefont-ttf \
    fonts-liberation \
    ttf-mscorefonts-installer \
    cabextract \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/* /var/tmp/* /usr/share/man /usr/local/man /usr/local/share/man \
 && mkdir -p /config/tmp /config/extras \
 && chown -R abc:abc /config \
 && chmod -R 777 /config

COPY --from=builder /tika-server-standard-${VERSION}.jar /app/tika-server-standard-${VERSION}.jar
USER 65000:65000

VOLUME ["/tmp"]
EXPOSE 9998
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/base-entrypoint.sh"]
CMD [ "/bin/sh", "-c", "java -cp \"/app/tika-server-standard-${VERSION}.jar:/config/extras/*\" org.apache.tika.server.core.TikaServerCli -h 0.0.0.0 $0 $@"]

LABEL org.opencontainers.image.source="https://github.com/apache/tika/"
