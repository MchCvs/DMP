#!/bin/bash
C=$(nproc)
M=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | tr -d '"\\' | xargs)
L=$(cut -d' ' -f1 /proc/loadavg)
ID="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$ID/$LG/a1.sh" ] || LG=fr
. "$ID/$LG/a1.sh"
if [ "$C" -ge 8 ]; then LV=3; elif [ "$C" -ge 4 ]; then LV=2; else LV=1; fi
case "$M" in
*Core*i3*) GM=3;;
*Core*i5*) GM=5;;
*Core*i7*) GM=7;;
*Core*i9*) GM=9;;
esac
case "$M" in
*Core*i[3579]*) FA=intel;;
*Ryzen*) FA=amd;;
*) FA=other;;
esac
OV=""; awk "BEGIN{exit !($L>$C)}" && OV=1
Y=""
if [[ "$M" =~ i[3579]-([0-9]{4,5}) ]]; then n=${BASH_REMATCH[1]}
 if [ ${#n} -eq 5 ] || [ "${n:0:1}" = 1 ]; then g=${n:0:2}; else g=${n:0:1}; fi; Y=$((2009+g))
elif [[ "$M" =~ Ryzen\ [3579]\ ([0-9]{4}) ]]; then
 case ${BASH_REMATCH[1]:0:1} in 1) Y=2017;; 2) Y=2018;; 3) Y=2019;; 4) Y=2021;; 5) Y=2020;; 6|7) Y=2022;; *) Y=2024;; esac
fi
AC=""
if [ -n "$Y" ]; then A=$(( $(date +%Y) - Y ))
 if [ $A -le 3 ]; then AC=new; elif [ $A -le 6 ]; then AC=mid; else AC=old; fi
fi
T_O
NV=0
[[ "$R" =~ "À surveiller" ]] && NV=1
[[ "$R" =~ "À corriger" ]] && NV=2
NV=0
[[ "$R" =~ "À surveiller" ]] && NV=1
[[ "$R" =~ "À corriger" ]] && NV=2
printf '{"comprendre":"%s","observations":"%s","resultat":"%s","informations_techniques":{"cores":%s,"load":%s,"model":"%s","cmd":"%s"},"niveau":%s}
' "$T_COMP" "$O" "$R" "$C" "$L" "$M" "$T_CMD" "$NV"
