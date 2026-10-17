#!/usr/bin/env bash

set -u

interface=""
ipv4=""
gateway=""
ipv6_global=0
ipv6_link_local=0
dns_servers=()

while read -r name state addresses; do
    [ "$name" = "lo" ] && continue

    interface="$name"

    for address in $addresses; do
        case "$address" in
            *.*/*)
                ipv4="${address%/*}"
                ;;
            *:*)
                if [[ "$address" == fe80:* ]]; then
                    ipv6_link_local=$((ipv6_link_local + 1))
                else
                    ipv6_global=$((ipv6_global + 1))
                fi
                ;;
        esac
    done

    [ -n "$interface" ] && break
done < <(ip -br address)

gateway="$(
    ip route |
    awk '$1 == "default" {print $3; exit}'
)"

while read -r server; do
    [ -n "$server" ] && dns_servers+=("$server")
done < <(
    awk '/^[[:space:]]*nameserver[[:space:]]+/ {print $2}' /etc/resolv.conf
)

gateway_reachable=false
ping_average_ms=""

if [ -n "$gateway" ]; then
    ping_output="$(
        ping -c 3 -W 2 "$gateway" 2>/dev/null || true
    )"

    if printf '%s\n' "$ping_output" |
        grep -q '3 received\|3 packets received'; then
        gateway_reachable=true
    fi

    ping_average_ms="$(
        printf '%s\n' "$ping_output" |
        awk -F'=' '/rtt/ {
            split($2, a, "/")
            print a[2]
        }'
    )"
fi

printf '{\n'
printf '  "module": "A4",\n'
printf '  "element": "réseau",\n'
printf '  "collected": true,\n'
printf '  "interface": "%s",\n' "$interface"
printf '  "ipv4": "%s",\n' "$ipv4"
printf '  "gateway": "%s",\n' "$gateway"
printf '  "gateway_reachable": %s,\n' "$gateway_reachable"
printf '  "gateway_average_ms": "%s",\n' "$ping_average_ms"
printf '  "ipv6_global_count": %s,\n' "$ipv6_global"
printf '  "ipv6_link_local_count": %s,\n' "$ipv6_link_local"

printf '  "dns_servers": ['
first_dns=1

for dns in "${dns_servers[@]}"; do
    if [ "$first_dns" -eq 0 ]; then
        printf ','
    fi
    first_dns=0
    printf '"%s"' "$dns"
done

printf ']\n'
printf '}\n'
