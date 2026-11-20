# Textes français du collecteur a1. Ne modifier que le texte.
T_COMP="$(tr_cle a1.comp)"
T_CMD="$(tr_cle a1.cmd)"
T_O() {
case $LV in
3) Q="un nombre élevé : votre ordinateur peut faire beaucoup de choses en même temps (vidéo, navigation, jeux) sans ralentir";;
2) Q="un nombre confortable pour un usage courant : internet, bureautique, vidéos";;
*) Q="un nombre modeste : l'ordinateur peut ralentir si on lance beaucoup de choses en même temps";;
esac
O="$(tr_cle a1.observations m="$M" c="$C" q="$Q" l="$L")"
case $GM in
3) GN="$(tr_cle a1.gamme.entree_de_gamme.nom)"; GX="$(tr_cle a1.gamme.entree_de_gamme.texte)";;
5) GN="$(tr_cle a1.gamme.milieu_de_gamme.nom)"; GX="$(tr_cle a1.gamme.milieu_de_gamme.texte)";;
7) GN="$(tr_cle a1.gamme.haut_de_gamme.nom)"; GX="$(tr_cle a1.gamme.haut_de_gamme.texte)";;
9) GN="$(tr_cle a1.gamme.tres_haut_de_gamme.nom)"; GX="$(tr_cle a1.gamme.tres_haut_de_gamme.texte)";;
esac
case $FA in
intel) E="$(tr_cle a1.cpu.intel gn="$GN" gx="$GX")";;
amd) E="Qu'est-ce qu'un Ryzen ? AMD est l'un des deux grands fabricants de processeurs (l'autre est Intel). Ryzen est sa gamme grand public, classée par niveau : Ryzen 3 (entrée de gamme), 5 (milieu de gamme, le plus courant), 7 (haut de gamme), 9 (très haut de gamme). Le nombre qui suit indique la génération : plus il est grand, plus le processeur est récent. Pourquoi c'est utile de le savoir : cela vous dit ce que votre ordinateur peut faire confortablement.";;
*) E="Le nom de votre processeur indique son fabricant et son niveau de puissance. Comparez-le à d'autres modèles du même fabricant pour savoir s'il est récent et puissant.";;
esac
O="$O $E"
case $LV in
3) U="$(tr_cle a1.usage.3 c="$C")";;
2) U="$(tr_cle a1.usage.2 c="$C")";;
*) U="Il suffit pour internet et la bureautique légère, mais il est limité dès qu'on fait plusieurs choses à la fois, car $C cœurs seulement se partagent le travail.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="$(tr_cle a1.age.neuf)";; mid) D="$(tr_cle a1.age.mid)";; *) D="$(tr_cle a1.age.ancien)";; esac
 AG="$(tr_cle a1.age d=$D y=$Y)"
else AG="$(tr_cle a1.age.inconnu)"; fi
if [ -n "$OV" ]; then R="$(tr_cle a1.verdict.surcharge)"; else R="$(tr_cle a1.verdict.ok)"; fi
R="$R. $U $AG"
}
