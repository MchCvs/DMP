# Textes français du collecteur d2. Ne modifier que le texte.
T_COMP="Supprimer, c'est désinstaller un logiciel dont vous n'avez plus besoin. Cette page vous montre les plus gros, à quoi ils servent, et comment les retirer sans risque. Pourquoi : un ordinateur allégé démarre plus vite et garde de la place pour l'essentiel."
T_R="Aucune suppression nécessaire"
T_CMD="apt-mark showmanual, dpkg-query"
T_MO="Mo"
T_ROLE="Rôle :"
T_CAN="Peut-on le supprimer ?"
T_X="Aucune suppression n'est faite par DMP : cette page vous montre quoi, pourquoi et comment, vous gardez la décision. Règle simple pour un débutant : ne supprimez rien ici. Ne pas reconnaître un nom ne veut pas dire qu'il est inutile : les logiciels les plus importants du système sont justement ceux qu'on ne voit jamais. Supprimez seulement un logiciel dont vous comprenez le rôle (par exemple un jeu ou une application installée par vous) ET dont vous êtes certain de ne plus avoir besoin."
T_PKG(){ case "$1" in
 linux-image*) echo "Le noyau Linux : le cœur de Debian. Il fait le lien entre le matériel (écran, disque, clavier) et les programmes. Sans lui, l'ordinateur ne démarre pas.";;
 linux-headers*|linux-kbuild*|linux-compiler*) echo "Des fichiers qui servent à fabriquer des pilotes pour le noyau (par exemple celui d'une carte graphique). Utile surtout aux utilisateurs avancés.";;
 firefox*) echo "Firefox : le navigateur internet qui affiche les sites web.";;
 chromium*|google-chrome*|brave*) echo "Un navigateur internet : il affiche les sites web.";;
 thunderbird*) echo "Thunderbird : le logiciel de messagerie (courriels).";;
 libreoffice*) echo "LibreOffice : la suite bureautique (traitement de texte, tableur, présentations), équivalent libre de Word et Excel.";;
 gimp*) echo "GIMP : retouche de photos et de dessins, équivalent libre de Photoshop.";;
 inkscape*) echo "Inkscape : dessin vectoriel (logos, illustrations qui restent nettes à toute taille).";;
 vlc*|mpv*) echo "Lecteur de vidéos et de musique, qui lit presque tous les formats.";;
 audacity*) echo "Audacity : enregistrement et montage de sons.";;
 kdenlive*|openshot*|shotcut*) echo "Logiciel de montage vidéo.";;
 blender*) echo "Blender : création d'images et de films en 3D.";;
 steam*) echo "Steam : boutique et lanceur de jeux vidéo.";;
 wine*) echo "Wine : permet de lancer certains programmes Windows sous Linux.";;
 code|codium) echo "Visual Studio Code : éditeur pour écrire des programmes.";;
 nodejs|npm) echo "Node.js : un environnement pour faire tourner des programmes écrits en JavaScript.";;
 openjdk*|default-jre*|default-jdk*) echo "Java : nécessaire pour lancer certains logiciels écrits en Java.";;
 docker*|podman*) echo "Gestion de « conteneurs » : des boîtes isolées pour faire tourner des logiciels sans toucher au reste du système.";;
 virtualbox*|qemu*) echo "Création d'ordinateurs virtuels : un autre système tourne dans une fenêtre.";;
 texlive*) echo "TeX Live : composition de documents scientifiques et de livres (LaTeX). Très volumineux.";;
 nvidia*|xserver-xorg-video*) echo "Pilote de la carte graphique : il permet de l'utiliser à pleine puissance.";;
 firmware-*|amd64-microcode|intel-microcode) echo "Micrologiciel : un petit programme intégré à un composant (wifi, carte graphique, processeur) pour qu'il fonctionne correctement.";;
 task-*) echo "Un lot de logiciels installé d'un coup (bureau, langue...). Le supprimer ne retire pas les logiciels, seulement le regroupement.";;
 gnome-*|gnome|kde-*|plasma-*|xfce4*) echo "Un élément du bureau graphique : fenêtres, menus, icônes, réglages.";;
 grub*) echo "GRUB : le programme qui lance Debian au démarrage de l'ordinateur.";;
 libc6*|systemd|systemd-*) echo "Un élément de base du système, indispensable à presque tous les programmes.";;
 python3*|python3-*) echo "Python : un langage de programmation. Plusieurs outils de Debian s'en servent.";;
 gcc*|g++*|build-essential|make|cmake) echo "Outils pour fabriquer des logiciels à partir de leur code source. Inutiles si vous ne programmez pas.";;
 git|git-*) echo "Git : suivi des versions d'un projet de programmation.";;
 mariadb*|mysql*|postgresql*) echo "Un gestionnaire de bases de données : il range de grandes quantités d'informations de façon organisée.";;
 apache2*|nginx*) echo "Un serveur web : il met des sites internet à disposition sur le réseau.";;
 cups*) echo "Gestion de l'impression.";;
 ufw) echo "ufw : le pare-feu, il bloque les connexions venues de l'extérieur que vous n'avez pas autorisées.";;
 smartmontools) echo "Surveille la santé des disques (utilisé par la page B4).";;
 locales*|keyboard-configuration|console-setup*) echo "Réglages de langue et de clavier.";;
 esac; }
T_SEC(){ case "$1" in
 libs|libdevel|oldlibs) echo "Une bibliothèque : un morceau de code partagé par plusieurs logiciels, comme un livre de recettes que plusieurs cuisiniers consultent. Elle est installée parce qu'un autre logiciel en a besoin.";;
 python|perl|interpreters) echo "Un module pour un langage de programmation, dont d'autres logiciels dépendent.";;
 kernel) echo "Un élément du noyau (le cœur du système).";;
 fonts) echo "Des polices de caractères : elles donnent l'aspect des lettres à l'écran et dans les documents.";;
 doc) echo "De la documentation : des manuels et des aides.";;
 devel|vcs) echo "Un outil pour programmer. Inutile si vous ne créez pas de logiciels.";;
 games) echo "Un jeu.";;
 graphics|photo) echo "Un logiciel de photo, de dessin ou d'image.";;
 video|sound|libs/multimedia) echo "Un logiciel de vidéo ou de son.";;
 web|net|mail|httpd) echo "Un logiciel pour internet ou le réseau.";;
 admin|utils|shells|misc) echo "Un outil d'entretien du système ou un utilitaire.";;
 x11|gnome|kde|xfce) echo "Un élément du bureau graphique : fenêtres, menus, icônes.";;
 editors|text) echo "Un éditeur ou un outil de texte.";;
 science|math) echo "Un logiciel scientifique ou de calcul.";;
 database) echo "Un gestionnaire de bases de données.";;
 *) echo "Un logiciel installé sur votre ordinateur (catégorie : $1). Pour sa description officielle, tapez « apt show nom_du_logiciel » (en anglais).";;
 esac; }
T_SU(){ local p="$1" pri="$2"; case "$p" in
 linux-image*) echo "⛔ NON : sans noyau, l'ordinateur ne démarre pas. Debian garde l'ancien en secours, laissez-le faire.";;
 grub*) echo "⛔ NON : GRUB lance Debian à l'allumage. Le retirer peut rendre l'ordinateur impossible à démarrer et empêcher les futures mises à jour du noyau.";;
 intel-microcode|amd64-microcode) echo "⛔ NON : il corrige au démarrage des failles de sécurité du processeur (type Spectre). Sans lui l'ordinateur démarre, mais ces failles restent ouvertes.";;
 firmware-*) echo "⛔ NON : c'est le programme interne dont un composant a besoin pour fonctionner (graphique, Wi-Fi...). Sans lui : écran dégradé ou noir, composant inutilisable.";;
 locales*) echo "⛔ NON : il gère la langue, les accents et les dates. Sans lui : messages d'erreur, caractères cassés, et de nombreux logiciels cessent de fonctionner.";;
 systemd*|libc6*|apt|dpkg|bash|coreutils|sudo|initramfs-tools*|xserver*|network-manager*|tzdata|ca-certificates|keyboard-configuration|console-setup*|ufw) echo "⛔ NON : élément de base du système, d'autres logiciels en dépendent. Le retirer peut empêcher l'ordinateur de fonctionner.";;
 *) case $pri in required|important) echo "⛔ NON : le système en a besoin pour fonctionner.";; *) echo "🟠 À laisser, sauf si vous savez précisément à quoi il sert et que vous êtes certain de ne pas en avoir besoin. Un nom inconnu n'est PAS une raison de supprimer : beaucoup de logiciels utiles sont invisibles.";; esac;;
 esac; }
T_O() {
O="🗑️ Supprimer un logiciel, c'est le désinstaller pour libérer de la place et alléger le système.${NL}Pourquoi le faire : un logiciel inutile occupe de la place, peut recevoir des mises à jour pour rien et augmente les risques de faille.${NL}${NL}📖 Les 3 façons de supprimer${NL}   • apt remove nom : retire le logiciel mais garde ses réglages (pratique si vous le réinstallez).${NL}   • apt purge nom : retire le logiciel ET ses réglages (propre et complet).${NL}   • apt autoremove : retire les logiciels devenus inutiles (installés pour en servir d'autres).${NL}${NL}⛔ DANGER : règles de prudence${NL}   • Lisez toujours la liste proposée par apt avant de répondre O. Si elle contient « linux-image », « systemd », « grub » ou « libc », répondez N : l'ordinateur pourrait ne plus démarrer.${NL}   • En cas de doute, ne supprimez pas.${NL}${NL}🏋️ Vos 12 logiciels installés volontairement les plus lourds${NL}   Pourquoi : ce sont ceux qui pèsent le plus lourd, pas ceux qu'il faut supprimer. Pour chacun : à quoi il sert, et si vous pouvez le retirer.${NL}$TOP"
}
