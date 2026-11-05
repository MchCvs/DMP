# Textes français du collecteur a5. Ne modifier que le texte.
T_COMP="$(tr_cle a5.comp)"
T_COMP_NO="La carte graphique fabrique l'image que vous voyez à l'écran."
T_NO_O="$(tr_cle a5.no_o)"
T_NO_R="$(tr_cle a5.no_r)"
T_CMD="$(tr_cle a5.cmd)"
T_O() {
case $GK in
ded) K="C'est une carte dédiée : une pièce séparée, puissante, pensée pour les jeux et le montage vidéo."
XU="Elle est suffisante pour les jeux et le montage vidéo, car c'est une pièce dédiée avec sa propre puissance.";;
*) K="C'est une puce graphique intégrée : elle est dans le processeur, suffit pour internet, la vidéo et la bureautique, mais est moins adaptée aux jeux récents."
XU="Elle est suffisante pour internet, les vidéos (même en HD), les photos et la bureautique. Pour les jeux 3D récents ou le montage vidéo lourd elle sera limitée, car elle partage la puissance avec le processeur.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="récente";; mid) D="d'âge moyen";; *) D="ancienne";; esac
 AG="Âge : d'après son nom, c'est une puce $D, sortie vers $Y (il y a environ $A an(s)). Pourquoi cela compte : une puce récente est plus rapide, consomme moins d'énergie et sait lire les vidéos les plus récentes sans fatiguer le processeur ; une ancienne reste correcte pour internet et la bureautique, mais peine sur les vidéos modernes et les jeux récents."
else AG=""; fi
X="$XU $AG"
O="$(tr_cle a5.observations g="$G" k="$K")"
if [ "$GK" = int ]; then R="Carte intégrée au processeur"; else R="Carte dédiée"; fi
}
