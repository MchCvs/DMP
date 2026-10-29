#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/b5.sh" ] || LG=fr
. "$I18/$LG/b5.sh"
F=$(ip route | awk '/default/{print $5;exit}')
[ -z "$F" ] && { j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_NO_CMD"; exit; }
GW=$(ip route | awk '/default/{print $3;exit}'); IP=$(ip -4 -o addr show "$F" | awk '{print $4}' | head -1)
DNS=$(awk '/^nameserver/{print $2}' /etc/resolv.conf | head -2 | paste -sd, | sed 's/,/, /g')
KW=0; [ -d /sys/class/net/$F/wireless ] && KW=1
case "$F" in en*) N1=en;; wl*) N1=wl;; *) N1=other;; esac
case "$F" in *o[0-9]*) N2=onboard;; en*p*s*) N2=pci;; *) N2=none;; esac
SP=$(cat /sys/class/net/$F/speed 2>/dev/null); SQ=0
if [ -n "$SP" ] && [ "$SP" -gt 0 ] 2>/dev/null; then
 if [ "$SP" -ge 1000 ]; then SQ=3; elif [ "$SP" -ge 100 ]; then SQ=2; else SQ=1; fi
fi
S=/sys/class/net/$F/statistics
RB=$(cat $S/rx_bytes); TB=$(cat $S/tx_bytes); RP=$(cat $S/rx_packets); TP=$(cat $S/tx_packets)
ER=$(( $(cat $S/rx_errors)+$(cat $S/tx_errors) )); DR=$(( $(cat $S/rx_dropped)+$(cat $S/tx_dropped) ))
RH=$(numfmt --to=iec --suffix=$T_BYTE $RB); TH=$(numfmt --to=iec --suffix=$T_BYTE $TB)
US=$(cut -d. -f1 /proc/uptime); UH=$((US/3600)); [ $UH -lt 1 ] && UH=1; UD=$((US/86400)); UHR=$((US%86400/3600))
MH=$(numfmt --to=iec --suffix=$T_BYTE $((RB/UH))); PH=$((RB/1048576))
if [ $RB -gt $((TB*3)) ]; then BL=dl; elif [ $TB -gt $RB ]; then BL=up; else BL=even; fi
pg(){ o=$(ping -c3 -i0.2 -W1 "$1" 2>/dev/null); L=$(echo "$o" | sed -n 's/.* \([0-9]*\)% packet loss.*/\1/p'); A=$(echo "$o" | sed -n 's#.*= [0-9.]*/\([0-9.]*\)/.*#\1#p'); }
pg "$GW"; GL=$L; GA=$A; pg 1.1.1.1; IL=$L; IA=$A
getent hosts debian.org >/dev/null 2>&1 && DN=1 || DN=0
TOT=$((RP+TP)); [ $TOT -lt 1 ] && TOT=1
PCT=$(awk -v d=$DR -v t=$TOT 'BEGIN{printf "%.2f",d*100/t}')
LV=0; awk -v p=$PCT 'BEGIN{exit !(p>=0.1)}' && LV=1; awk -v p=$PCT 'BEGIN{exit !(p>=1)}' && LV=2; [ $ER -gt 0 ] && LV=2
PF=/tmp/dmp-b5-drops; SK=first; DD=0; MN=0
if [ -f $PF ]; then read PD PT < $PF; if [ "$DR" -ge "$PD" ]; then MN=$(( ($(date +%s)-PT)/60 )); DD=$((DR-PD)); SK=delta; fi; fi
echo "$DR $(date +%s)" > $PF
if [ -z "$GL" ] || [ "$GL" = 100 ]; then ST=nobox
elif [ -z "$IL" ] || [ "$IL" = 100 ]; then ST=noinet
elif [ "$IL" -gt 0 ]; then ST=unstable
elif [ $DN = 0 ]; then ST=nodns
else ST=ok; fi
T_O
export NV=$LV
export X; j "$T_COMP" "$O" "$R" "$T_CMD"
