# Textes français du collecteur a2. Ne modifier que le texte.
T_COMP="$(tr_cle a2.comp)"
T_CMD="$(tr_cle a2.cmd)"
T_O() {
case $LV in
3) Q="$(tr_cle a2.quantite.3)"
XU="Elle est largement suffisante, même pour le montage vidéo ou plusieurs logiciels lourds en même temps, car ces tâches gardent beaucoup de données sur le bureau.";;
2) Q="$(tr_cle a2.quantite.2)"
XU="Elle est suffisante pour un usage courant (internet avec beaucoup d'onglets, bureautique, vidéos, photos). Pour du montage vidéo lourd elle serait juste, car ces tâches remplissent vite le bureau.";;
1) Q="$(tr_cle a2.quantite.1)"
XU="Elle suffit pour internet et la bureautique, mais devient juste avec beaucoup d'onglets, car les navigateurs récents sont gourmands.";;
*) Q="$(tr_cle a2.quantite.0)"
XU="Elle est petite : elle suffit pour un usage léger, et tient mieux avec peu de programmes ouverts.";;
esac
case $PL in
0) XE="En ce moment vous n'en utilisez qu'une partie ($P %) : vous avez de la marge.";;
1) XE="Elle est assez utilisée ($P %) : elle commence à peser, fermez les programmes dont vous n'avez plus besoin.";;
*) XE="Elle est presque pleine ($P %) : fermez des programmes ou des onglets.";;
esac
R="$(tr_cle a2.verdict.0)"; [ "$PL" = 1 ] && R="$(tr_cle a2.verdict.1)"; [ "$PL" = 2 ] && R="$(tr_cle a2.verdict.2)"
X="$XU $XE"
O="$(tr_cle a2.observations t="$T" q="$Q" p="$P" d="$D")"
}
