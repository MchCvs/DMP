#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
read T A ST SF <<< $(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}/SwapTotal/{st=$2}/SwapFree/{sf=$2}END{printf "%.1f %.1f %.1f %.1f",t/1048576,a/1048576,st/1048576,(st-sf)/1048576}' /proc/meminfo)
P=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%d",(t-a)*100/t}' /proc/meminfo)
TOP=$(ps -eo pmem,comm --sort=-pmem --no-headers | head -3 | awk '{printf "   • %s : %s %% de la mémoire\n",$2,$1}')
O="🧠 Mémoire utilisée : $P % sur $T Go (il reste $A Go disponibles)${NL}${NL}Les 3 plus gros consommateurs :${NL}$TOP${NL}${NL}🔁 Mémoire de secours (swap, sur le disque) : $SF Go utilisés sur $ST Go${NL}Pourquoi : quand le bureau est plein, le système range des choses sur le disque, bien plus lent. Beaucoup de swap utilisé veut dire que la mémoire a manqué."
R="Mémoire à l'aise"; X="Il reste beaucoup de place : les programmes s'ouvrent vite."
[ $P -ge 85 ] && { R="Mémoire presque pleine"; X="Fermez des onglets ou des programmes (surtout ceux de la liste), sinon l'ordinateur va ralentir en utilisant le disque comme secours."; }
[ $P -ge 60 ] && [ $P -lt 85 ] && { R="Mémoire bien utilisée, encore correcte"; X="C'est normal : Linux garde volontairement de la mémoire pour accélérer, et la rend dès qu'un programme en a besoin."; }
NV=0; [ $P -ge 85 ] && NV=2; dmp_niveau $NV
export X; j "Cette page montre combien le bureau de travail de votre ordinateur (la mémoire) est rempli en ce moment, et par quoi." "$O" "$R" "/proc/meminfo, ps"
