#!/usr/bin/env bash
set -u

interfaces="$(ip -br addr 2>/dev/null || true)"
routes="$(ip route 2>/dev/null || true)"

gateway="$(
    ip route 2>/dev/null |
    awk '$1=="default" {print $3; exit}'
)"

dns="$(
    resolvectl dns 2>/dev/null || true
)"

if [ -z "$dns" ]; then
    dns="$(
        grep -E '^[[:space:]]*nameserver[[:space:]]+' \
            /etc/resolv.conf 2>/dev/null || true
    )"
fi

[ -n "$interfaces" ] || interfaces="Information non disponible"
[ -n "$routes" ] || routes="Information non disponible"
[ -n "$gateway" ] || gateway="Information non disponible"
[ -n "$dns" ] || dns="Information non disponible"

local_ping=""
internet_ping=""
ipv4_resolution=""
ipv6_resolution=""

if [ "$gateway" != "Information non disponible" ]; then
    local_ping="$(ping -c 3 -W 2 "$gateway" 2>/dev/null || true)"
fi

internet_ping="$(ping -c 3 -W 2 1.1.1.1 2>/dev/null || true)"
ipv4_resolution="$(getent ahostsv4 debian.org 2>/dev/null || true)"
ipv6_resolution="$(getent ahostsv6 debian.org 2>/dev/null || true)"

local_ok="false"
internet_ok="false"
ipv4_ok="false"
ipv6_ok="false"

printf '%s\n' "$local_ping" |
    grep -q "0% packet loss" && local_ok="true"

printf '%s\n' "$internet_ping" |
    grep -q "0% packet loss" && internet_ok="true"

[ -n "$ipv4_resolution" ] && ipv4_ok="true"
[ -n "$ipv6_resolution" ] && ipv6_ok="true"

python3 - "$interfaces" "$routes" "$gateway" "$dns" "$local_ok" "$internet_ok" "$ipv4_ok" "$ipv6_ok" "$local_ping" "$internet_ping" "$ipv4_resolution" "$ipv6_resolution" <<'PY'
import json
import sys

print(json.dumps({
    "module": "B5",
    "element": "reseau",
    "collected": True,
    "interfaces": sys.argv[1],
    "routes": sys.argv[2],
    "gateway": sys.argv[3],
    "dns": sys.argv[4],
    "local_ok": sys.argv[5] == "true",
    "internet_ok": sys.argv[6] == "true",
    "ipv4_ok": sys.argv[7] == "true",
    "ipv6_ok": sys.argv[8] == "true",
    "local_ping": sys.argv[9],
    "internet_ping": sys.argv[10],
    "ipv4_resolution": sys.argv[11],
    "ipv6_resolution": sys.argv[12]
}, ensure_ascii=False, indent=2))
PY
