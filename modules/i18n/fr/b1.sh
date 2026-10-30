# Textes français du collecteur b1. Ne modifier que le texte.
T_COMP="Cette page dit depuis quand votre ordinateur est allumé sans interruption, et s'il est fatigué. C'est comme demander à quelqu'un depuis combien d'heures il travaille sans pause."
T_CMD="uptime, /proc/uptime, /proc/loadavg"
T_O() {
if [ $J -gt 0 ]; then T="$J jour(s), $H h $M min"; else T="$H h $M min"; fi
O="⏱️ Allumé depuis : $T (démarrage le $DEP)${NL}${NL}⚙️ Charge du processeur : $L pour $C cœurs${NL}Pourquoi : tant que ce nombre reste sous $C, chaque cœur a sa tâche et l'ordinateur reste fluide."
case $UL in
long) R="Allumé depuis longtemps : un redémarrage est conseillé"; X="Au bout d'un mois, des programmes ont laissé des restes en mémoire et certaines mises à jour (notamment le noyau, le cœur du système) ne s'appliquent qu'après un redémarrage, donc vous n'en profitez pas encore.";;
mid) R="Allumé depuis plusieurs jours : tout va bien"; X="Redémarrer de temps en temps (une fois par semaine ou deux) est une bonne habitude, car cela remet la mémoire à zéro et applique les mises à jour.";;
*) R="Pas de redémarrage en attente"; X="La machine tourne depuis un certain temps, et aucune mise à jour n'attend un redémarrage.";;
esac
[ -n "$RB" ] && X="$X Important : le système signale qu'un redémarrage est nécessaire pour finir une mise à jour."
}
