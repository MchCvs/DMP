#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C; SC=0
I18="$(dirname "$0")/../i18n"; LGG=${DMP_LANG:-fr}; [ -f "$I18/$LGG/b9.sh" ] || LGG=fr
. "$I18/$LGG/b9.sh"
UP=$(apt list --upgradable 2>/dev/null | grep -c upgradable); SU=$(apt list --upgradable 2>/dev/null | grep -ci security)
ST=/var/lib/apt/periodic/update-success-stamp; [ -f $ST ] && AG=$(( ($(date +%s)-$(stat -c %Y $ST))/86400 )) || AG=-1
if [ $SU -gt 0 ]; then MC=sec; SC=2
elif [ $UP -gt 0 ]; then MC=ord; [ $SC -lt 1 ] && SC=1
else MC=ok; fi
AC=none
[ $AG -ge 7 ] && { AC=old; [ $SC -lt 1 ] && SC=1; }
[ $AG -ge 0 ] && [ $AG -lt 7 ] && AC=recent
dpkg -s unattended-upgrades >/dev/null 2>&1 && AUC=1 || AUC=0
if [ -f /var/run/reboot-required ]; then RBC=1; [ $SC -lt 1 ] && SC=1; else RBC=0; fi
FW=""; for s in ufw nftables firewalld; do systemctl is-active --quiet $s 2>/dev/null && FW="$s"; done
grep -qiE "^ENABLED=yes" /etc/ufw/ufw.conf 2>/dev/null && FW=ufw
EXP=0; LOC=0; PT=""
while read -r a; do p=${a##*:}; h=${a%:*}
 case "$h" in 127.*|"[::1]"|::1) LOC=$((LOC+1)); T_PORTL;; *) EXP=$((EXP+1)); T_PORTE;; esac
done < <(ss -tlnH 2>/dev/null | awk '{print $4}' | sort -u)
[ $EXP -gt 3 ] && SC=2; [ $EXP -gt 0 ] && [ $SC -lt 1 ] && SC=1
SSHC=stopped; if systemctl is-active --quiet ssh 2>/dev/null || systemctl is-active --quiet sshd 2>/dev/null; then PR=$(grep -hiE '^\s*PermitRootLogin' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/* 2>/dev/null | tail -1 | awk '{print $2}'); case "$PR" in yes) SSHC=danger; SC=2;; *) SSHC=active;; esac; fi
AA=$(cat /sys/module/apparmor/parameters/enabled 2>/dev/null); [ "$AA" = Y ] && AAC=1 || AAC=0
LG=$(last -n 60 -w 2>/dev/null | grep -v -e '^$' -e wtmp -e reboot | head -5 | sed 's/^/   • /')
T_O
export NV=$SC
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
