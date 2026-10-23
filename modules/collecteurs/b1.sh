#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'
S=$(cut -d. -f1 /proc/uptime); J=$((S/86400)); H=$((S%86400/3600)); M=$((S%3600/60))
[ $J -gt 0 ] && T="$J jour(s), $H h $M min" || T="$H h $M min"
L=$(cut -d' ' -f1 /proc/loadavg); C=$(nproc); DEP=$(uptime -s)
O="⏱️ Allumé depuis : $T (démarrage le $DEP)${NL}${NL}⚙️ Charge du processeur : $L pour $C cœurs${NL}Pourquoi : tant que ce nombre reste sous $C, chaque cœur a sa tâche et l'ordinateur reste fluide."
R="Allumé depuis moins d'une semaine"; X="Un ordinateur allumé depuis peu n'a pas encore accumulé de restes en mémoire : rien à faire. Un redémarrage reste utile après une mise à jour du noyau."
if [ $J -ge 30 ]; then R="Allumé depuis longtemps : un redémarrage est conseillé"; X="Au bout d'un mois, des programmes ont laissé des restes en mémoire et certaines mises à jour (notamment le noyau, le cœur du système) ne s'appliquent qu'après un redémarrage, donc vous n'en profitez pas encore."
elif [ $J -ge 7 ]; then R="Allumé depuis plusieurs jours : tout va bien"; X="Redémarrer de temps en temps (une fois par semaine ou deux) est une bonne habitude, car cela remet la mémoire à zéro et applique les mises à jour."; fi
[ -f /var/run/reboot-required ] && X="$X Important : le système signale qu'un redémarrage est nécessaire pour finir une mise à jour."
NV=0; [ $J -ge 30 ] && NV=1; [ -f /var/run/reboot-required ] && NV=1; dmp_niveau $NV
export X; j "Cette page dit depuis quand votre ordinateur est allumé sans interruption, et s'il est fatigué. C'est comme demander à quelqu'un depuis combien d'heures il travaille sans pause." "$O" "$R" "uptime, /proc/uptime, /proc/loadavg"
