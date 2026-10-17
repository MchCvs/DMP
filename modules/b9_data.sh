#!/usr/bin/env bash
set -u

apparmor="Information non disponible"
firewall="Information non disponible"
ssh="Information non disponible"
updates="Information non disponible"

# AppArmor :
# aa-status fournit des informations détaillées lorsqu'il est installé.
# À défaut, DMP vérifie directement l'état du module dans le noyau
# et l'état du service AppArmor.
if command -v aa-status >/dev/null 2>&1; then
    if aa-status --enabled >/dev/null 2>&1; then
        apparmor="actif"
    else
        apparmor="inactif"
    fi
elif [ -r /sys/module/apparmor/parameters/enabled ] &&
     [ "$(cat /sys/module/apparmor/parameters/enabled 2>/dev/null)" = "Y" ]; then
    if systemctl is-active --quiet apparmor.service 2>/dev/null; then
        apparmor="actif"
    else
        apparmor="module AppArmor actif mais service inactif"
    fi
fi

# Pare-feu :
# L'absence de ufw, nftables et iptables ne permet pas de conclure
# à l'absence d'un pare-feu. DMP distingue donc les outils absents
# d'un pare-feu effectivement déclaré actif ou inactif.
if command -v ufw >/dev/null 2>&1; then
    ufw_status="$(ufw status 2>/dev/null || true)"
    case "$ufw_status" in
        *"Status: active"*)
            firewall="actif (ufw)"
            ;;
        *"Status: inactive"*)
            firewall="inactif (ufw)"
            ;;
    esac
fi

if [ "$firewall" = "Information non disponible" ] &&
   command -v nft >/dev/null 2>&1; then
    if systemctl is-active --quiet nftables.service 2>/dev/null; then
        firewall="actif (nftables)"
    else
        firewall="inactif (nftables)"
    fi
fi

if [ "$firewall" = "Information non disponible" ] &&
   command -v iptables >/dev/null 2>&1; then
    if systemctl is-active --quiet netfilter-persistent.service 2>/dev/null; then
        firewall="actif (iptables)"
    else
        firewall="Information non disponible"
    fi
fi

ssh_status="$(dpkg-query -W -f='${Status}' openssh-server 2>/dev/null || true)"

case "$ssh_status" in
    "install ok installed")
        if systemctl is-active --quiet ssh.service 2>/dev/null; then
            ssh="actif"
        else
            ssh="serveur SSH installé mais inactif"
        fi
        ;;
    *)
        ssh="serveur SSH non installé"
        ;;
esac

if command -v apt >/dev/null 2>&1; then
    updates="$(
        apt list --upgradable 2>/dev/null |
        awk 'NR > 1 {count++} END {
            if (count == 0)
                print "aucune mise à jour disponible"
            else
                print count " mise(s) à jour disponible(s)"
        }'
    )"
fi

[ -n "$updates" ] || updates="Information non disponible"

python3 - "$apparmor" "$firewall" "$ssh" "$updates" <<'PY'
import json
import sys

print(json.dumps({
    "module": "B9",
    "element": "securite",
    "collected": True,
    "apparmor": sys.argv[1],
    "firewall": sys.argv[2],
    "ssh": sys.argv[3],
    "updates": sys.argv[4]
}, ensure_ascii=False, indent=2))
PY
