# Textes français du collecteur a2. Ne modifier que le texte.
T_COMP="$(tr_cle a2.comp)"
T_CMD="$(tr_cle a2.cmd)"
T_O() {
case $LV in
3) Q="$(tr_cle a2.quantite.3)"
XU="$(tr_cle a2.usage.3)";;
2) Q="$(tr_cle a2.quantite.2)"
XU="$(tr_cle a2.usage.2)";;
1) Q="$(tr_cle a2.quantite.1)"
XU="$(tr_cle a2.usage.1)";;
*) Q="$(tr_cle a2.quantite.0)"
XU="$(tr_cle a2.usage.0)";;
esac
case $PL in
0) XE="$(tr_cle a2.marge p="$P")";;
1) XE="Elle est assez utilisée ($P %) : elle commence à peser, fermez les programmes dont vous n'avez plus besoin.";;
*) XE="Elle est presque pleine ($P %) : fermez des programmes ou des onglets.";;
esac
R="$(tr_cle a2.verdict.0)"; [ "$PL" = 1 ] && R="$(tr_cle a2.verdict.1)"; [ "$PL" = 2 ] && R="$(tr_cle a2.verdict.2)"
X="$XU $XE"
O="$(tr_cle a2.observations t="$T" q="$Q" p="$P" d="$D")"
}
