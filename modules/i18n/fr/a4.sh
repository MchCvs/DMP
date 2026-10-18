# Textes français du collecteur a4. Ne modifier que le texte.
T_COMP="Le réseau est la porte de votre ordinateur vers le reste du monde : internet, imprimante, autres appareils."
T_NO_O="Aucune connexion active n'est détectée : l'ordinateur n'a pas de chemin vers internet. Pourquoi : le câble est peut-être débranché ou le Wi-Fi désactivé. Sans connexion, impossible de naviguer ou de faire les mises à jour."
T_NO_R="Non connecté"
T_NO_CMD="ip route"
T_CMD="ip route, ip addr"
T_O() {
if [ -n "$WL" ]; then K="en Wi-Fi (sans fil)"; XU="Le Wi-Fi est pratique, mais sa qualité dépend de la distance à la box et des murs : si les pages sont lentes, rapprochez-vous ou passez par un câble."
else K="par câble"; XU="Le câble est en général plus stable et plus rapide que le Wi-Fi, car le signal ne subit pas d'interférences."; fi
X="Cette connexion suffit pour naviguer, regarder des vidéos et faire les mises à jour. $XU"
O="Votre ordinateur est connecté $K, via l'interface « $F ». Son adresse sur le réseau est $A : c'est comme son numéro de maison, qui permet aux autres appareils de le trouver. Pourquoi c'est important : sans cette adresse, aucune page web ni mise à jour ne pourrait arriver jusqu'à vous."
R="Connecté"
}
