# Textes français du collecteur c4. Ne modifier que le texte ; garder les ${...} et $NL tels quels.
T_TITLE="Identité relevée"
T_COMP="Les informations techniques sont la carte d'identité de votre ordinateur : modèle, système, version. Pourquoi : quand on dépanne ou installe un logiciel, on commence toujours par ces informations."
T_X="Ces informations ne changent presque jamais : elles servent surtout quand on demande de l'aide, car elles permettent à quelqu'un de comprendre exactement votre configuration. Notez-les ou copiez-les."
T_AR64="64 bits : le standard actuel, capable d'utiliser plus de 4 Go de mémoire"
T_AR32="32 bits : ancien, limité à 4 Go de mémoire"
T_O() {
O="🪪 Voici la carte d'identité de votre ordinateur.${NL}${NL}🖥️ Machine : ${MOD:-non lisible} (nom sur le réseau : $HOST)${NL}   Pourquoi : permet de retrouver la documentation et les pilotes exacts.${NL}${NL}🐧 Système : $PRETTY_NAME${NL}   Pourquoi : détermine les logiciels disponibles et la durée des mises à jour de sécurité.${NL}${NL}🫀 Noyau (cœur du système) : $KERNEL${NL}   Pourquoi : c'est lui qui parle au matériel ; sa version donne la compatibilité avec les composants récents.${NL}${NL}⚙️ Architecture : $AR${NL}   Pourquoi : détermine quels logiciels peuvent s'installer.${NL}${NL}🔧 Outils de DMP : Python $PYV, Bash $BASHV${NL}   Pourquoi : ce sont les outils qui permettent à DMP de lire et d'expliquer votre machine.${NL}${NL}🌍 Langue du système : ${LANG:-non définie}${NL}   Pourquoi : choisit la langue des menus, la date et l'orthographe des accents.${NL}${NL}🖼️ Session graphique : ${DESK:-non détectée} (${SESS:-?})${NL}   Pourquoi : c'est le type de bureau, qui détermine l'apparence et le fonctionnement des fenêtres."
}
