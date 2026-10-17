#!/usr/bin/env bash

set -u

network=""
disks=""
audio=""
usb=""

# Interface réseau Ethernet
network="$(
    lspci 2>/dev/null |
    grep -Ei 'Ethernet controller|Network controller' |
    head -n 1 || true
)"

# Disques durs
disks="$(
    lsblk -dn -o NAME,MODEL,SIZE 2>/dev/null || true
)"

# Son
audio="$(
    cat /proc/asound/cards 2>/dev/null || true
)"

# USB
usb="$(
    lsusb 2>/dev/null || true
)"

[ -n "$network" ] || network="Information non disponible"
[ -n "$disks" ] || disks="Information non disponible"
[ -n "$audio" ] || audio="Information non disponible"
[ -n "$usb" ] || usb="Information non disponible"

python3 - "$network" "$disks" "$audio" "$usb" <<'PY'
import json
import sys

print(json.dumps({
    "module": "A8",
    "element": "peripheriques",
    "collected": True,
    "network": sys.argv[1],
    "disks": sys.argv[2],
    "audio": sys.argv[3],
    "usb": sys.argv[4]
}, ensure_ascii=False, indent=2))
PY
