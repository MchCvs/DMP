#!/bin/bash
source "$(dirname "$0")/lib.sh"
T=$(awk '/MemTotal/{printf "%.1f",$2/1048576}' /proc/meminfo)
D=$(awk '/MemAvailable/{printf "%.1f",$2/1048576}' /proc/meminfo)
P=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%d",(t-a)*100/t}' /proc/meminfo)
I=${T%.*}
if [ "$I" -ge 16 ]; then Q="une très grande quantité : vous pouvez ouvrir beaucoup de choses en même temps sans souci"; elif [ "$I" -ge 8 ]; then Q="une quantité confortable pour internet, la bureautique, les vidéos et un peu de création"; elif [ "$I" -ge 4 ]; then Q="une quantité correcte mais juste si vous ouvrez beaucoup de choses"; else Q="une quantité faible : l'ordinateur peut vite ralentir"; fi
R="Mémoire en bonne forme"; [ "$P" -ge 85 ] && R="Mémoire presque pleine : l'ordinateur risque de ralentir"
if [ "$I" -ge 16 ]; then XU="Elle est largement suffisante, même pour le montage vidéo ou plusieurs logiciels lourds en même temps, car ces tâches gardent beaucoup de données sur le bureau."
elif [ "$I" -ge 8 ]; then XU="Elle est suffisante pour un usage courant (internet avec beaucoup d'onglets, bureautique, vidéos, photos). Pour du montage vidéo lourd elle serait juste, car ces tâches remplissent vite le bureau."
elif [ "$I" -ge 4 ]; then XU="Elle suffit pour internet et la bureautique, mais devient juste avec beaucoup d'onglets, car les navigateurs récents sont gourmands."
else XU="Elle est faible : l'ordinateur sera lent dès qu'on ouvre plusieurs choses, car le bureau est trop petit."; fi
if [ "$P" -lt 60 ]; then XE="En ce moment vous n'en utilisez qu'une partie ($P %) : vous avez de la marge."; elif [ "$P" -lt 85 ]; then XE="Elle est assez utilisée ($P %) mais reste correcte."; else XE="Elle est presque pleine ($P %) : fermez des programmes ou des onglets."; fi
dmp_niveau 0; [ "$P" -ge 85 ] && dmp_niveau 2
export X="$XU $XE"
j "La mémoire (RAM) est le bureau de travail de votre ordinateur : tout ce que vous ouvrez y est posé pour être utilisé très vite. Quand vous éteignez, le bureau est vidé." "Votre ordinateur a $T Go de mémoire, $Q. En ce moment $P % est occupé et il reste $D Go libres. Pourquoi c'est important : quand le bureau est plein, l'ordinateur doit ranger des choses sur le disque, qui est bien plus lent, et tout ralentit. Tant qu'il reste de la place libre, tout reste fluide." "$R" "/proc/meminfo"
