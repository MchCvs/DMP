# Textes français du collecteur a3. Ne modifier que le texte.
T_COMP="Les disques sont les armoires de votre ordinateur : c'est là que tout est rangé de façon permanente."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="support USB amovible (clé USB = mémoire flash ; disque dur externe = flash ou mécanique)";;
ssd) K="SSD (sans pièce mobile : rapide, silencieux, résistant aux chocs)";;
*) K="disque dur mécanique (un plateau tourne : plus lent, il s'use avec les années)";;
esac
}
T_PART() { PT="$PT${NL}   • Partition $pn ($ps, $pf) montée sur $pm : $u utilisé"; }
T_DISK() { D="$D${NL}${NL}💽 Disque $N : « $n » — ${m:-modèle inconnu}${NL}   • Capacité : $G Go${NL}   • Type : $K$PT"; }
T_O() {
case $SL in
3) SU="Cette capacité est largement suffisante pour documents, photos et de nombreux films. Seuls les jeux lourds ou la vidéo 4K en grande quantité pourraient la remplir, car ces fichiers sont très volumineux.";;
2) SU="Cette capacité est suffisante pour un usage courant, mais photos et vidéos la remplissent vite : surveillez l'espace restant.";;
*) SU="Cette capacité est limitée : photos et vidéos la rempliront vite, pensez à un disque externe.";;
esac
O="$(tr_cle a3.observations n="$N" d="$D" s="$S" p="$P" u="$U" a="$A")"
R="Espace suffisant"; [ $NP -ge 75 ] && R="Espace à surveiller"; [ $NP -ge 90 ] && R="Disque principal presque plein : à libérer rapidement"
}
