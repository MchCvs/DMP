#!/bin/bash
source "$(dirname "$0")/lib.sh"
I18="$(dirname "$0")/../i18n"; LG=${DMP_LANG:-fr}; [ -f "$I18/$LG/a5.sh" ] || LG=fr
. "$I18/$LG/a5.sh"
G=$(LC_ALL=C lspci 2>/dev/null | grep -iE 'vga|3d|display' | cut -d: -f3- | xargs)
if [ -z "$G" ]; then j "$T_COMP_NO" "$T_NO_O" "$T_NO_R" "$T_CMD"; exit; fi
case "$G" in *NVIDIA*|*Radeon\ RX*|*Radeon\ Pro*) GK=ded;; *) GK=int;; esac
Y=""
case "$G" in
*"HD Graphics 2500"*|*"HD Graphics 4000"*|*Ivy*) Y=2012;; *Haswell*|*"HD Graphics 4600"*) Y=2013;; *Broadwell*|*Skylake*) Y=2015;; *Kaby*|*Coffee*|*"UHD Graphics 6"*) Y=2017;; *Comet*|*"Ice Lake"*|*Tiger*|*"Iris Xe"*) Y=2020;; *Alder*|*Raptor*) Y=2022;; *Meteor*|*Arrow*|*Lunar*) Y=2024;;
*Raven*) Y=2018;; *Picasso*) Y=2019;; *Renoir*) Y=2020;; *Cezanne*) Y=2021;;
esac
if [ -z "$Y" ] && [[ "$G" =~ (GTX|RTX|GT)\ ?([0-9]{3,4}) ]]; then n=${BASH_REMATCH[2]}; s=${n:0:${#n}-2}
 case $s in 4|5) Y=2012;; 6) Y=2012;; 7) Y=2014;; 9) Y=2015;; 10) Y=2016;; 16) Y=2019;; 20) Y=2018;; 30) Y=2020;; 40) Y=2022;; 50) Y=2025;; esac; fi
if [ -z "$Y" ] && [[ "$G" =~ RX\ ?([0-9]{3,4}) ]]; then n=${BASH_REMATCH[1]}
 if [ ${#n} -eq 3 ]; then [ "${n:0:1}" = 4 ] && Y=2016 || Y=2017; else case ${n:0:1} in 5) Y=2019;; 6) Y=2020;; 7) Y=2022;; 9) Y=2025;; esac; fi; fi
AC=""
if [ -n "$Y" ]; then A=$(( $(date +%Y) - Y ))
 if [ $A -le 3 ]; then AC=new; elif [ $A -le 6 ]; then AC=mid; else AC=old; fi
fi
T_O
export X
export NV=$LV
j "$T_COMP" "$O" "$R" "$T_CMD"
