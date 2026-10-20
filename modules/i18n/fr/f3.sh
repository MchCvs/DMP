T_COMP="Le test de vitesse (benchmark) est comme chronométrer un coureur : on fait faire à l'ordinateur un effort identique à chaque fois, pour savoir à quelle vitesse il va et suivre son évolution."
T_CMD="python3, dd (DMP uniquement)"
T_DKU="type non lisible"
T_SSD="SSD"
T_HDD="disque dur mécanique"
T_V0="✅ très bon"
T_V1="🟡 correct"
T_V2="🔴 faible"
T_O() {
O="⚡ Le test mesure à l'instant la vitesse de trois pièces. Il dure quelques secondes et écrit 512 Mo temporaires dans votre dossier personnel, supprimés aussitôt.${NL}${NL}1) 🧮 Calcul (processeur) : $CT s pour 5 millions d'opérations${NL}   • Pourquoi : c'est la vitesse à laquelle l'ordinateur « réfléchit ». Plus c'est court, mieux c'est.${NL}   • Repères : moins de 0,8 s très bon, de 0,8 à 1,6 s correct, plus de 1,6 s faible.${NL}   • Votre résultat : $(vd $LC)${NL}${NL}2) 🧠 Mémoire : $MM Mo/s${NL}   • Pourquoi : c'est la vitesse à laquelle les données circulent dans le bureau de travail. Elle conditionne la fluidité de tous les programmes.${NL}   • Repères : plus de 4000 Mo/s très bon, de 1500 à 4000 correct, moins de 1500 faible.${NL}   • Votre résultat : $(vd $LM)${NL}${NL}3) 💽 Disque (écriture, $DK) : $DW Mo/s${NL}   • Pourquoi : c'est la vitesse d'enregistrement des fichiers, des mises à jour et du démarrage.${NL}   • Repères : plus de 300 Mo/s très bon (SSD), de 100 à 300 correct, moins de 100 faible (disque dur mécanique ou disque occupé).${NL}   • Votre résultat : $(vd $LD)"
}
T_RX() {
case $W in
0) R="Machine rapide"; X="Les trois mesures sont bonnes : processeur, mémoire et disque suivent. Refaites ce test de temps en temps : une baisse nette signale un problème (disque fatigué, programme en arrière-plan).";;
1) R="Vitesse moyenne : à surveiller"; X="Au moins une mesure est seulement correcte. Rien d'anormal pour un usage courant. Si la machine vous paraît lente, la mesure la plus faible indique la pièce à regarder.";;
*) R="Vitesse faible : à améliorer"; X="Au moins une mesure est faible : c'est la pièce qui limite votre ordinateur. Le disque est le plus facile à améliorer (un SSD change tout). Relancez le test sans autre programme ouvert pour vérifier que ce n'est pas passager.";;
esac
}
