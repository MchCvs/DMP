#!/usr/bin/env bash

set -u

BASE="${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

C1="$BASE/c1_data.sh"
C2="$BASE/c2_1_data.sh"

updates_detected=false
updates_count=0

autoremove_detected=false
autoremove_count=0

cleanup_detected=false
apt_cache_bytes=0
apt_cache_human="0 B"

status="ok"

#
# C1 — Mises à jour
#
if [[ -x "$C1" ]]; then
    C1_OUTPUT="$("$C1" 2>/dev/null || true)"

    eval "$(
        python3 - "$C1_OUTPUT" <<'PY'
import json
import shlex
import sys

try:
    data = json.loads(sys.argv[1])

    print("updates_available=" + shlex.quote(
        str(data.get("updates_available", False)).lower()
    ))

    print("update_count=" + shlex.quote(
        str(data.get("update_count", 0))
    ))

except Exception:
    print("updates_available=false")
    print("update_count=0")
PY
    )"

    if [[ "$updates_available" == "true" ]]; then
        updates_detected=true
    fi

    if [[ "$update_count" =~ ^[0-9]+$ ]]; then
        updates_count="$update_count"
    fi
fi

#
# C2.1 — Nettoyage et autoremove
#
if [[ -x "$C2" ]]; then
    C2_OUTPUT="$("$C2" 2>/dev/null || true)"

    eval "$(
        python3 - "$C2_OUTPUT" <<'PY'
import json
import shlex
import sys

try:
    data = json.loads(sys.argv[1])

    print("apt_cache_bytes=" + shlex.quote(
        str(data.get("apt_cache_bytes", 0))
    ))

    print("apt_cache_human=" + shlex.quote(
        str(data.get("apt_cache_human", "0 B"))
    ))

    print("unused_packages=" + shlex.quote(
        str(data.get("unused_packages", 0))
    ))

except Exception:
    print("apt_cache_bytes=0")
    print("apt_cache_human='0 B'")
    print("unused_packages=0")
PY
    )"

    if [[ "$apt_cache_bytes" =~ ^[0-9]+$ ]]; then
        :
    else
        apt_cache_bytes=0
    fi

    if [[ "$unused_packages" =~ ^[0-9]+$ ]]; then
        autoremove_count="$unused_packages"
    fi
fi

#
# Possibilité de nettoyage
#
if (( apt_cache_bytes > 0 )); then
    cleanup_detected=true

    if [[ -z "${apt_cache_human:-}" ]]; then
        apt_cache_human="0 B"
    fi
fi

#
# Possibilité d'autoremove
#
if (( autoremove_count > 0 )); then
    autoremove_detected=true
fi

#
# Interprétation DMP
#
updates_interpretation=""
autoremove_interpretation=""
cleanup_interpretation=""

if [[ "$updates_detected" == "true" ]]; then
    updates_interpretation="$updates_count mise(s) à jour disponible(s)."
else
    updates_interpretation="Aucune mise à jour disponible actuellement."
fi

if [[ "$autoremove_detected" == "true" ]]; then
    autoremove_interpretation="$autoremove_count paquet(s) peuvent être examinés pour une suppression."
else
    autoremove_interpretation="Aucun paquet inutile détecté actuellement."
fi

if [[ "$cleanup_detected" == "true" ]]; then
    cleanup_interpretation="Un nettoyage du cache APT peut être envisagé. Taille actuelle : $apt_cache_human."
else
    cleanup_interpretation="Aucun cache APT à nettoyer détecté."
fi

#
# Sortie JSON
#
python3 - \
    "$status" \
    "$updates_detected" \
    "$updates_count" \
    "$autoremove_detected" \
    "$autoremove_count" \
    "$cleanup_detected" \
    "$apt_cache_bytes" \
    "$apt_cache_human" \
    "$updates_interpretation" \
    "$autoremove_interpretation" \
    "$cleanup_interpretation" \
    <<'PY'
import json
import sys

(
    status,
    updates_detected,
    updates_count,
    autoremove_detected,
    autoremove_count,
    cleanup_detected,
    apt_cache_bytes,
    apt_cache_human,
    updates_interpretation,
    autoremove_interpretation,
    cleanup_interpretation,
) = sys.argv[1:]

result = {
    "module": "c3",
    "status": status,

    "possibilities": {
        "updates": {
            "detected": updates_detected == "true",
            "count": int(updates_count),
        },

        "autoremove": {
            "detected": autoremove_detected == "true",
            "count": int(autoremove_count),
        },

        "cleanup": {
            "detected": cleanup_detected == "true",
            "apt_cache_bytes": int(apt_cache_bytes),
            "apt_cache_human": apt_cache_human,
        },
    },

    "details": {
        "updates": [],
        "autoremove": [],
    },

    "interpretation": {
        "updates": updates_interpretation,
        "autoremove": autoremove_interpretation,
        "cleanup": cleanup_interpretation,
    },
}

print(json.dumps(result, ensure_ascii=False, indent=2))
PY
