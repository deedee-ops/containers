#!/usr/bin/env bash

#shellcheck disable=SC2086
exec \
    /usr/bin/jellyfin \
        --ffmpeg="/usr/lib/jellyfin-ffmpeg/ffmpeg" \
        --webdir="/usr/share/jellyfin/web" \
        --datadir="/config" \
        --cachedir="/config/cache" \
        "$@"
