# Textes français du collecteur c2. Ne modifier que le texte.
T_COMP="Un paquet est un logiciel rangé dans la bibliothèque de Debian, prêt à être installé ou retiré proprement. Cette page fait l'inventaire de cette bibliothèque. Pourquoi : savoir ce qui est installé et en bon état évite les conflits."
T_CMD="dpkg-query, apt-mark, dpkg --audit (DMP uniquement)"
T_BIGFMT='%d) %s : %.0f Mo\n   • Rôle : %s\n'
T_O() {
O="📦 Paquets installés : $NI${NL}   Pourquoi : un paquet est un logiciel prêt à installer (comme une appli sur un téléphone). Debian en regroupe des dizaines de milliers.${NL}${NL}💽 Place occupée par tous les paquets : $TOT Go${NL}   Pourquoi : c'est la taille de tous les programmes installés, sans vos fichiers personnels.${NL}${NL}🙋 Installés volontairement : $MAN${NL}🔗 Installés automatiquement (dépendances) : $((NI-MAN))${NL}   Pourquoi : certains logiciels ont besoin d'autres pour fonctionner. Ces derniers s'installent seuls, et on peut les retirer quand plus rien n'en a besoin (voir page C3).${NL}${NL}🧱 Paquets bloqués volontairement : $HOLD${NL}   Pourquoi : un paquet « bloqué » est exclu des mises à jour. Zéro est la situation normale.${NL}${NL}🔧 Paquets cassés ou mal installés : $BRK${NL}   Pourquoi : un paquet interrompu en cours d'installation peut gêner les futures mises à jour. Zéro est attendu.${NL}${NL}🗑️ Restes de configuration de logiciels supprimés : $RC${NL}   Pourquoi : à la suppression d'un logiciel, Debian garde ses réglages au cas où vous le réinstalleriez. Ils occupent très peu de place.${NL}${NL}🏋️ Les 10 paquets les plus lourds${NL}   Pourquoi : savoir ce qui occupe le plus de place avant de vouloir en libérer.${NL}$BIG"
case $HL in
brk) R="Paquets à réparer"; X="Des paquets sont mal installés. Tapez « sudo apt --fix-broken install » : cela termine les installations interrompues. À faire avant toute mise à jour.";;
hold) R="Des paquets sont bloqués"; X="$HOLD paquet(s) ne seront pas mis à jour. Si ce n'est pas voulu, tapez « sudo apt-mark unhold nom_du_paquet ».";;
*) R="Paquets en bon état"; X="Aucun paquet cassé ni bloqué : le système de logiciels est sain, les mises à jour pourront s'installer sans accroc.";;
esac
}
