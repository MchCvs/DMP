# Textes français du collecteur a3. Ne modifier que le texte.
T_COMP="$(tr_cle a3.comprendre)"
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="$(tr_cle a3.type.usb)";;
ssd) K="$(tr_cle a3.type.ssd)";;
*) K="$(tr_cle a3.type.mecanique)";;
esac
}
T_PART() { PT="$PT${NL}   • $(tr_cle a3.partition pn="$pn" ps="$ps" pf="$pf" pm="$pm" u="$u")"; }
T_DISK() { D="$D${NL}${NL}$(tr_cle a3.disque n="$N" nom="$n" modele="${m:-modèle inconnu}")${NL}   • $(tr_cle a3.capacite g="$G")${NL}   • $(tr_cle a3.type_disque k="$K")$PT"; }
T_O() {
case $SL in
3) SU="Cette capacité est largement suffisante pour documents, photos et de nombreux films. Seuls les jeux lourds ou la vidéo 4K en grande quantité pourraient la remplir, car ces fichiers sont très volumineux.";;
2) SU="Cette capacité est suffisante pour un usage courant, mais photos et vidéos la remplissent vite : surveillez l'espace restant.";;
*) SU="Cette capacité est limitée : photos et vidéos la rempliront vite, pensez à un disque externe.";;
esac
O="$(tr_cle a3.observations n="$N" d="$D" s="$(fmt_taille "$S")" p="$P" u="$(fmt_taille "$U")" a="$(fmt_taille "$A")")"
R="$(tr_cle a3.verdict.0)"; [ $NP -ge 75 ] && R="$(tr_cle a3.verdict.1)"; [ $NP -ge 90 ] && R="$(tr_cle a3.verdict.2)"
}
