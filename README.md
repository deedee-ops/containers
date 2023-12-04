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
[authelia](https://github.com/deedee-ops/containers/pkgs/container/authelia) | stable | ghcr.io/deedee-ops/authelia |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.37](https://img.shields.io/badge/4.37-blue?style=flat-square) ![4.37.5](https://img.shields.io/badge/4.37.5-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[csp-exporter](https://github.com/deedee-ops/containers/pkgs/container/csp-exporter) | stable | ghcr.io/deedee-ops/csp-exporter |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.1](https://img.shields.io/badge/0.1-blue?style=flat-square) ![0.1.0](https://img.shields.io/badge/0.1.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[lldap](https://github.com/deedee-ops/containers/pkgs/container/lldap) | stable | ghcr.io/deedee-ops/lldap |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.5](https://img.shields.io/badge/0.5-blue?style=flat-square) ![0.5.0](https://img.shields.io/badge/0.5.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[lldap-devel](https://github.com/deedee-ops/containers/pkgs/container/lldap-devel) | devel | ghcr.io/deedee-ops/lldap-devel |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.5](https://img.shields.io/badge/0.5-blue?style=flat-square) ![0.5.1](https://img.shields.io/badge/0.5.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[maddy](https://github.com/deedee-ops/containers/pkgs/container/maddy) | stable | ghcr.io/deedee-ops/maddy |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.7](https://img.shields.io/badge/0.7-blue?style=flat-square) ![0.7.0](https://img.shields.io/badge/0.7.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[navidrome](https://github.com/deedee-ops/containers/pkgs/container/navidrome) | stable | ghcr.io/deedee-ops/navidrome |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.50](https://img.shields.io/badge/0.50-blue?style=flat-square) ![0.50.1](https://img.shields.io/badge/0.50.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[postgres-init](https://github.com/deedee-ops/containers/pkgs/container/postgres-init) | stable | ghcr.io/deedee-ops/postgres-init |![16](https://img.shields.io/badge/16-blue?style=flat-square) ![16.1](https://img.shields.io/badge/16.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[postgres-logical-backup](https://github.com/deedee-ops/containers/pkgs/container/postgres-logical-backup) | stable | ghcr.io/deedee-ops/postgres-logical-backup |![16](https://img.shields.io/badge/16-blue?style=flat-square) ![16.1](https://img.shields.io/badge/16.1-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)
[syncthing](https://github.com/deedee-ops/containers/pkgs/container/syncthing) | stable | ghcr.io/deedee-ops/syncthing |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.27](https://img.shields.io/badge/1.27-blue?style=flat-square) ![1.27.0](https://img.shields.io/badge/1.27.0-blue?style=flat-square) ![latest](https://img.shields.io/badge/latest-green?style=flat-square)


## Credits

A lot of inspiration (and a lot of copy-pasting to be honest) are thanks to the hard work of [onedr0p](https://github.com/onedr0p) containers and home-ops infrastructure.

<!--
vim:ft=markdown
-->