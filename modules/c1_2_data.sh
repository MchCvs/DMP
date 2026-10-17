#!/usr/bin/env bash
set -u

installed_count=0
config_files_count=0
abnormal_count=0
packages_with_config_files=""
collected=false

if command -v dpkg-query >/dev/null 2>&1; then

    installed_count="$(
        dpkg-query -W -f='${Status}\n' 2>/dev/null |
        grep -c '^install ok installed$' || true
    )"

    config_files_count="$(
        dpkg-query -W -f='${Status}\n' 2>/dev/null |
        grep -c '^deinstall ok config-files$' || true
    )"

    packages_with_config_files="$(
        dpkg-query -W -f='${db:Status-Abbrev} ${binary:Package}\n' 2>/dev/null |
        awk '$1 == "rc" {print $2}' || true
    )"

    abnormal_count="$(
        printf '%s\n' "$packages_with_config_files" |
        grep -c . || true
    )"

    collected=true
fi

python3 - \
    "$collected" \
    "$installed_count" \
    "$config_files_count" \
    "$abnormal_count" \
    "$packages_with_config_files" <<'PY'
import json
import sys

collected = sys.argv[1].lower() == "true"
installed_count = int(sys.argv[2])
config_files_count = int(sys.argv[3])
abnormal_count = int(sys.argv[4])
packages_with_config_files = sys.argv[5]

print(json.dumps({
    "module": "C1.2",
    "element": "paquets_installes",
    "collected": collected,
    "installed_count": installed_count,
    "config_files_count": config_files_count,
    "abnormal_count": abnormal_count,
    "packages_with_config_files": packages_with_config_files
}, ensure_ascii=False, indent=2))
PY
