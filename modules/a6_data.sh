#!/usr/bin/env bash

set -u

manufacturer="$(
    cat /sys/class/dmi/id/board_vendor 2>/dev/null || true
)"

product="$(
    cat /sys/class/dmi/id/board_name 2>/dev/null || true
)"

version="$(
    cat /sys/class/dmi/id/board_version 2>/dev/null || true
)"

[ -n "$manufacturer" ] || manufacturer="Information non disponible"
[ -n "$product" ] || product="Information non disponible"
[ -n "$version" ] || version="Information non disponible"

printf '{\n'
printf '  "module": "A6",\n'
printf '  "element": "carte_mere",\n'
printf '  "collected": true,\n'
printf '  "manufacturer": "%s",\n' "$manufacturer"
printf '  "product": "%s",\n' "$product"
printf '  "version": "%s"\n' "$version"
printf '}\n'
