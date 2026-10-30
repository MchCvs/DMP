# Textes français du collecteur a6. Ne modifier que le texte.
T_COMP="La carte mère est la grande plaque centrale où tout se branche : processeur, mémoire, disque. C'est le squelette de l'ordinateur : si elle ne fonctionne pas, rien ne fonctionne."
T_COMP_NO="La carte mère est la grande plaque centrale où tout se branche : processeur, mémoire, disque. C'est le squelette de l'ordinateur."
T_NO_O="Ses informations ne sont pas lisibles ici. Pourquoi : c'est fréquent sur une machine virtuelle ou un portable qui les cache."
T_NO_R="Non disponible"
T_CMD="/sys/class/dmi/id"
T_O() {
if [ -n "$XA" ]; then [ "$XA" -le 1 ] && S="" || S="s"; XU="Le programme de démarrage date de $yr, soit environ $XA an$S : cela donne un ordre d'idée de l'âge de la carte mère. "; else XU=""; fi
X="${XU}Si l'ordinateur démarre et fonctionne bien, il n'y a rien à faire : mettre à jour le BIOS comporte un risque, donc on ne le fait que pour corriger un problème précis."
O="Votre carte mère est une « $N » du fabricant $V. Son programme de démarrage (BIOS) est en version $B, datée du $Y. Pourquoi c'est utile : le BIOS est le premier programme lancé quand vous allumez l'ordinateur. Une version très ancienne peut manquer de corrections, mais on ne la modifie que si nécessaire."
R="Identifiée"
}
