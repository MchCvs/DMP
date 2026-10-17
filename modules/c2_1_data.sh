#!/usr/bin/env bash
set -u

apt_cache_bytes=0
apt_cache_human="0 B"
thumbnails_bytes=0
thumbnails_human="0 B"
unused_packages=0
collected=false

if command -v du >/dev/null 2>&1; then

    if [ -d /var/cache/apt/archives ]; then
        apt_cache_bytes="$(
            du -sb /var/cache/apt/archives 2>/dev/null |
            awk '{print $1}'
        )"
        apt_cache_bytes="${apt_cache_bytes:-0}"

        apt_cache_human="$(
            numfmt --to=iec --suffix=B "$apt_cache_bytes" 2>/dev/null ||
            echo "${apt_cache_bytes} B"
        )"
    fi

    if [ -d "$HOME/.cache/thumbnails" ]; then
        thumbnails_bytes="$(
            du -sb "$HOME/.cache/thumbnails" 2>/dev/null |
            awk '{print $1}'
        )"
        thumbnails_bytes="${thumbnails_bytes:-0}"

        thumbnails_human="$(
            numfmt --to=iec --suffix=B "$thumbnails_bytes" 2>/dev/null ||
            echo "${thumbnails_bytes} B"
        )"
    fi

    collected=true
fi

if command -v apt-get >/dev/null 2>&1; then
    unused_packages="$(
        apt-get --dry-run autoremove 2>/dev/null |
        grep -c '^Remv' || true
    )"
fi

python3 - \
    "$collected" \
    "$apt_cache_bytes" \
    "$apt_cache_human" \
    "$thumbnails_bytes" \
    "$thumbnails_human" \
    "$unused_packages" <<'PY'
import json
import sys

(
    collected,
    apt_cache_bytes,
    apt_cache_human,
    thumbnails_bytes,
    thumbnails_human,
    unused_packages,
) = sys.argv[1:]

result = {
    "module": "C2.1",
    "element": "recherche_elements_inutiles",
    "collected": collected == "true",
    "apt_cache_bytes": int(apt_cache_bytes),
    "apt_cache_human": apt_cache_human,
    "thumbnails_bytes": int(thumbnails_bytes),
    "thumbnails_human": thumbnails_human,
    "unused_packages": int(unused_packages),
}

print(json.dumps(result, ensure_ascii=False, indent=2))
PY
