<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./github/scripts/templates/README.md.j2
-->
<div align="center">


## Containers

_A Collection of Container Images Optimized for Kubernetes_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/deedee-ops/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/deedee-ops/containers?style=for-the-badge)

</div>

Welcome to my container images, if looking for a container start by [browsing the container packages](https://github.com/deedee-ops?tab=packages&repo_name=containers).

## Mission statement

The goal of this project is to support containers for various applications, while following the best practices including:

- [Semantic versioning](https://semver.org/)
- [Multiple architectures](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/)
- Security best practices
    - [Rootless PID 1](https://rootlesscontaine.rs/)
    - [Restricted Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
    - [Read-Only Root Filesystem](https://www.tenable.com/audits/items/CIS_Docker_1.6_v1.0.0_L1_Docker.audit:9c37a2dfc2acaf6a234c6c6ac58128a8)
    - [Mount secrets as files](https://www.tenable.com/audits/items/CIS_Kubernetes_v1.6.1_Level_2_Master.audit:98de3da69271994afb6211cf86ae4c6b)
        - By default all files in `/secrets` will be passed to underlying process (i.e. `/secrets/MY_SECRET` contents will be passed as `MY_SECRET` env)
        - Also any env ending in `_FILE` will have underlying file passed (i.e. `MY_SECRET_FILE=/path/file` will result in `MY_SECRET=<contents of /path/file>`)
- Consistent behavior for all images
    - Use original image environment variables as closely as possible
    - Logging to stdout
    - [One process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/)
    - Consistent paths
        - All configuration data (files, sqlite databases, caches etc.) should live in `/config` endpoint
        - All assets (photos, movies, Linux ISOs) should live in `/data` endpoint
        - Writable `/tmp`

## Global env variables

These environment variables are universally available across all images:

| ENV                           | Default    | Description                                              |
|-------------------------------|------------|----------------------------------------------------------|
| `DEBUG_OS`                    | `""`       | When set to any value, implies `set -x`                  |
| `ENVDIR_DIRECTORY`            | `/secrets` | Directory to pick env variables from                     |
| `SKIP_FILE_SECRETS_EXPANSION` | `""`       | When set, all `_FILE` envs won't be expanded and checked |

## Tag immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers).

A similar approach applies here, but instead of appending a `-ls69` or `-r420` prefix to the tag, instead the sha256 digest of the image is used. While this is not as pretty it is just as functional in making the images immutable.

| Container                                                 | Immutable |
|-----------------------------------------------------------|-----------|
| `ghcr.io/deedee-ops/paperless-ngx:latest`                 | ❌         |
| `ghcr.io/deedee-ops/paperless-ngx:1.17.4`                 | ❌         |
| `ghcr.io/deedee-ops/paperless-ngx:latest@sha256:613c...`  | ✅         |
| `ghcr.io/deedee-ops/paperless-ngx:1.17.4@sha256:613c...`  | ✅         |

_If pinning an image to the sha256 digest, tools like [Renovate](https://github.com/renovatebot/renovate) support updating the container on a digest or application version change._

## Available Images

Each Image will be built with a `latest` tag, along with tags specific to it's version. Available Images Below

Container | Channel | Image | Latest Tags
--- | --- | --- | ---
[authelia](https://github.com/deedee-ops/containers/pkgs/container/authelia) | stable | ghcr.io/deedee-ops/authelia |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.38](https://img.shields.io/badge/4.38-blue?style=flat-square) ![4.38.8](https://img.shields.io/badge/4.38.8-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[bazarr](https://github.com/deedee-ops/containers/pkgs/container/bazarr) | stable | ghcr.io/deedee-ops/bazarr |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.4](https://img.shields.io/badge/1.4-blue?style=flat-square) ![1.4.2](https://img.shields.io/badge/1.4.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[csp-exporter](https://github.com/deedee-ops/containers/pkgs/container/csp-exporter) | stable | ghcr.io/deedee-ops/csp-exporter |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.1](https://img.shields.io/badge/0.1-blue?style=flat-square) ![0.1.0](https://img.shields.io/badge/0.1.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[firefly-iii](https://github.com/deedee-ops/containers/pkgs/container/firefly-iii) | stable | ghcr.io/deedee-ops/firefly-iii |![6](https://img.shields.io/badge/6-blue?style=flat-square) ![6.0](https://img.shields.io/badge/6.0-blue?style=flat-square) ![6.0.30](https://img.shields.io/badge/6.0.30-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[firefoxsync](https://github.com/deedee-ops/containers/pkgs/container/firefoxsync) | stable | ghcr.io/deedee-ops/firefoxsync |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.9](https://img.shields.io/badge/1.9-blue?style=flat-square) ![1.9.1](https://img.shields.io/badge/1.9.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[home-assistant](https://github.com/deedee-ops/containers/pkgs/container/home-assistant) | stable | ghcr.io/deedee-ops/home-assistant |![2024](https://img.shields.io/badge/2024-blue?style=flat-square) ![2024.4](https://img.shields.io/badge/2024.4-blue?style=flat-square) ![2024.4.4](https://img.shields.io/badge/2024.4.4-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[invidious-devel](https://github.com/deedee-ops/containers/pkgs/container/invidious-devel) | devel | ghcr.io/deedee-ops/invidious-devel |![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[jellyfin](https://github.com/deedee-ops/containers/pkgs/container/jellyfin) | stable | ghcr.io/deedee-ops/jellyfin |![10](https://img.shields.io/badge/10-blue?style=flat-square) ![10.8](https://img.shields.io/badge/10.8-blue?style=flat-square) ![10.8.13](https://img.shields.io/badge/10.8.13-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[jellystat](https://github.com/deedee-ops/containers/pkgs/container/jellystat) | stable | ghcr.io/deedee-ops/jellystat |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.0](https://img.shields.io/badge/1.0-blue?style=flat-square) ![1.0.9](https://img.shields.io/badge/1.0.9-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[jellystat-devel](https://github.com/deedee-ops/containers/pkgs/container/jellystat-devel) | devel | ghcr.io/deedee-ops/jellystat-devel |![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[lldap](https://github.com/deedee-ops/containers/pkgs/container/lldap) | stable | ghcr.io/deedee-ops/lldap |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.5](https://img.shields.io/badge/0.5-blue?style=flat-square) ![0.5.0](https://img.shields.io/badge/0.5.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[lldap-devel](https://github.com/deedee-ops/containers/pkgs/container/lldap-devel) | devel | ghcr.io/deedee-ops/lldap-devel |![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[maddy](https://github.com/deedee-ops/containers/pkgs/container/maddy) | stable | ghcr.io/deedee-ops/maddy |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.7](https://img.shields.io/badge/0.7-blue?style=flat-square) ![0.7.1](https://img.shields.io/badge/0.7.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[mbsync-devel](https://github.com/deedee-ops/containers/pkgs/container/mbsync-devel) | devel | ghcr.io/deedee-ops/mbsync-devel |![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[miniflux](https://github.com/deedee-ops/containers/pkgs/container/miniflux) | stable | ghcr.io/deedee-ops/miniflux |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.1](https://img.shields.io/badge/2.1-blue?style=flat-square) ![2.1.2](https://img.shields.io/badge/2.1.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[miniserve](https://github.com/deedee-ops/containers/pkgs/container/miniserve) | stable | ghcr.io/deedee-ops/miniserve |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.27](https://img.shields.io/badge/0.27-blue?style=flat-square) ![0.27.0](https://img.shields.io/badge/0.27.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[navidrome](https://github.com/deedee-ops/containers/pkgs/container/navidrome) | stable | ghcr.io/deedee-ops/navidrome |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.51](https://img.shields.io/badge/0.51-blue?style=flat-square) ![0.51.1](https://img.shields.io/badge/0.51.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[offlineimap-devel](https://github.com/deedee-ops/containers/pkgs/container/offlineimap-devel) | devel | ghcr.io/deedee-ops/offlineimap-devel |![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[paperless-ngx](https://github.com/deedee-ops/containers/pkgs/container/paperless-ngx) | stable | ghcr.io/deedee-ops/paperless-ngx |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.7](https://img.shields.io/badge/2.7-blue?style=flat-square) ![2.7.2](https://img.shields.io/badge/2.7.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[postgres-init](https://github.com/deedee-ops/containers/pkgs/container/postgres-init) | stable | ghcr.io/deedee-ops/postgres-init |![16](https://img.shields.io/badge/16-blue?style=flat-square) ![16.2](https://img.shields.io/badge/16.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[postgres-logical-backup](https://github.com/deedee-ops/containers/pkgs/container/postgres-logical-backup) | stable | ghcr.io/deedee-ops/postgres-logical-backup |![16](https://img.shields.io/badge/16-blue?style=flat-square) ![16.2](https://img.shields.io/badge/16.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[prowlarr](https://github.com/deedee-ops/containers/pkgs/container/prowlarr) | stable | ghcr.io/deedee-ops/prowlarr |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.16](https://img.shields.io/badge/1.16-blue?style=flat-square) ![1.16.2](https://img.shields.io/badge/1.16.2-blue?style=flat-square) ![1.16.2.4435](https://img.shields.io/badge/1.16.2.4435-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[prowlarr-devel](https://github.com/deedee-ops/containers/pkgs/container/prowlarr-devel) | devel | ghcr.io/deedee-ops/prowlarr-devel |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.16](https://img.shields.io/badge/1.16-blue?style=flat-square) ![1.16.2](https://img.shields.io/badge/1.16.2-blue?style=flat-square) ![1.16.2.4435](https://img.shields.io/badge/1.16.2.4435-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[prowlarr-nightly](https://github.com/deedee-ops/containers/pkgs/container/prowlarr-nightly) | nightly | ghcr.io/deedee-ops/prowlarr-nightly |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.17](https://img.shields.io/badge/1.17-blue?style=flat-square) ![1.17.0](https://img.shields.io/badge/1.17.0-blue?style=flat-square) ![1.17.0.4447](https://img.shields.io/badge/1.17.0.4447-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[radarr](https://github.com/deedee-ops/containers/pkgs/container/radarr) | stable | ghcr.io/deedee-ops/radarr |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.4](https://img.shields.io/badge/5.4-blue?style=flat-square) ![5.4.6](https://img.shields.io/badge/5.4.6-blue?style=flat-square) ![5.4.6.8723](https://img.shields.io/badge/5.4.6.8723-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[radarr-devel](https://github.com/deedee-ops/containers/pkgs/container/radarr-devel) | devel | ghcr.io/deedee-ops/radarr-devel |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.5](https://img.shields.io/badge/5.5-blue?style=flat-square) ![5.5.0](https://img.shields.io/badge/5.5.0-blue?style=flat-square) ![5.5.0.8730](https://img.shields.io/badge/5.5.0.8730-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[radarr-nightly](https://github.com/deedee-ops/containers/pkgs/container/radarr-nightly) | nightly | ghcr.io/deedee-ops/radarr-nightly |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.5](https://img.shields.io/badge/5.5-blue?style=flat-square) ![5.5.1](https://img.shields.io/badge/5.5.1-blue?style=flat-square) ![5.5.1.8747](https://img.shields.io/badge/5.5.1.8747-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[roundcube](https://github.com/deedee-ops/containers/pkgs/container/roundcube) | stable | ghcr.io/deedee-ops/roundcube |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.6](https://img.shields.io/badge/1.6-blue?style=flat-square) ![1.6.6](https://img.shields.io/badge/1.6.6-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[script-exporter](https://github.com/deedee-ops/containers/pkgs/container/script-exporter) | stable | ghcr.io/deedee-ops/script-exporter |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.18](https://img.shields.io/badge/2.18-blue?style=flat-square) ![2.18.0](https://img.shields.io/badge/2.18.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[sonarr](https://github.com/deedee-ops/containers/pkgs/container/sonarr) | stable | ghcr.io/deedee-ops/sonarr |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.0](https://img.shields.io/badge/4.0-blue?style=flat-square) ![4.0.4](https://img.shields.io/badge/4.0.4-blue?style=flat-square) ![4.0.4.1491](https://img.shields.io/badge/4.0.4.1491-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[sonarr-devel](https://github.com/deedee-ops/containers/pkgs/container/sonarr-devel) | devel | ghcr.io/deedee-ops/sonarr-devel |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.0](https://img.shields.io/badge/4.0-blue?style=flat-square) ![4.0.4](https://img.shields.io/badge/4.0.4-blue?style=flat-square) ![4.0.4.1515](https://img.shields.io/badge/4.0.4.1515-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[syncthing](https://github.com/deedee-ops/containers/pkgs/container/syncthing) | stable | ghcr.io/deedee-ops/syncthing |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.27](https://img.shields.io/badge/1.27-blue?style=flat-square) ![1.27.6](https://img.shields.io/badge/1.27.6-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[talosctl](https://github.com/deedee-ops/containers/pkgs/container/talosctl) | stable | ghcr.io/deedee-ops/talosctl |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.7](https://img.shields.io/badge/1.7-blue?style=flat-square) ![1.7.0](https://img.shields.io/badge/1.7.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[tika](https://github.com/deedee-ops/containers/pkgs/container/tika) | stable | ghcr.io/deedee-ops/tika |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.9](https://img.shields.io/badge/2.9-blue?style=flat-square) ![2.9.2](https://img.shields.io/badge/2.9.2-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)


## Credits

A lot of inspiration (and a lot of copy-pasting to be honest) are thanks to the hard work of [onedr0p](https://github.com/onedr0p) containers and home-ops infrastructure.

<!--
vim:ft=markdown
-->