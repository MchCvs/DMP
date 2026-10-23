#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
ME=$(id -un); MT=$(awk '/MemTotal/{print $2}' /proc/meminfo)
ALL=$(ps -e --no-headers | wc -l)
KT=$(ps -eo pid,ppid --no-headers | awk '$1==2||$2==2' | wc -l)
MINE=$(ps -u "$ME" --no-headers | wc -l); SYS=$((ALL-KT-MINE))
ZO=$(ps -eo stat --no-headers | grep -c '^Z')
AGG=$(ps -eo user:20,pid,ppid,pcpu,rss,stat,comm --no-headers | awk '{u=$1;pid=$2;pp=$3;cpu=$4;rss=$5;c=$0;for(i=1;i<=6;i++)sub(/^[ \t]*[^ \t]+[ \t]+/,"",c);if(pid==2||pp==2)next;n[c]++;cp[c]+=cpu;m[c]+=rss;us[c]=u}END{for(c in n)printf "%s|%d|%.1f|%d|%s\n",c,n[c],cp[c],m[c],us[c]}')
NP=$(echo "$AGG" | grep -c .)
TOP=$(echo "$AGG" | sort -t'|' -k4 -nr | head -20)
desc(){ case "$1" in
 systemd) echo "Le chef d'orchestre du système : il lance et surveille tous les autres services. Sans lui, rien ne démarre.";;
 systemd-*|dbus-daemon|dbus-broker*) echo "Service interne qui permet aux programmes de se parler entre eux et de gérer le système (journal, heure, connexions).";;
 NetworkManager|wpa_supplicant) echo "Gère la connexion au réseau et à internet.";;
 sshd|ssh) echo "Permet de se connecter à l'ordinateur à distance.";;
 cron|cron.service) echo "Lance les tâches programmées (nettoyages, sauvegardes).";;
 Xorg|Xwayland|gnome-shell|plasmashell|kwin*|xfwm4|xfdesktop|mutter) echo "Dessine votre bureau, les fenêtres et l'écran. Sans lui, vous ne voyez rien.";;
 gdm*|lightdm|sddm) echo "Affiche l'écran de connexion et ouvre votre session.";;
 firefox*|chrome*|chromium*|brave*) echo "Votre navigateur internet : il affiche les sites web.";;
 "Web Content"|WebExtensions|"Isolated Web Co"|"Privileged Cont"|RDD*|"Socket Process") echo "Morceaux du navigateur : chaque onglet ou extension tourne dans son propre processus.";;
 thunderbird*) echo "Votre messagerie (courriels).";;
 soffice*|libreoffice*) echo "LibreOffice : traitement de texte, tableur, présentations.";;
 vlc|mpv|totem) echo "Lecteur de vidéos et de musique.";;
 pipewire*|wireplumber|pulseaudio) echo "Gère le son : haut-parleurs, micro, casque.";;
 python*|node|java) echo "Un programme écrit dans un langage de script (ou un outil de développement). Ici il peut s'agir du serveur DMP lui-même.";;
 bash|sh|zsh|dash|fish) echo "Un terminal (la fenêtre où l'on tape des commandes) ou le script qui s'y exécute.";;
 cupsd|cups-browsed) echo "Gère l'impression.";;
 bluetoothd) echo "Gère le Bluetooth.";;
 avahi-daemon) echo "Aide l'ordinateur à découvrir les imprimantes et appareils du réseau local.";;
 rsyslogd) echo "Tient le journal des événements du système (utile pour comprendre un problème).";;
 polkitd|udisksd|upowerd|accounts-daemon|colord) echo "Service du système : gère les droits, les disques branchés, l'énergie ou les profils d'écran.";;
 gvfs*|tracker*|localsearch*) echo "Service de bureau : accès aux fichiers (réseau, clés USB) et recherche dans vos documents.";;
 code|codium) echo "L'éditeur de code Visual Studio Code.";;
 claude*) echo "L'assistant Claude Code utilisé dans le terminal.";;
 *) if [ "$2" = root ]; then echo "Programme du système lancé par l'administrateur (root). Il travaille en arrière-plan pour un service de Debian."; else echo "Programme lancé par vous ou par l'une de vos applications."; fi;;
 esac; }
LIST=""; i=0
while IFS='|' read -r c n cp m u; do [ -z "$c" ] && continue; i=$((i+1))
 MEM=$(awk -v k=$m 'BEGIN{if(k>=1048576)printf "%.1f Go",k/1048576;else printf "%d Mo",k/1024}'); PC=$(awk -v k=$m -v t=$MT 'BEGIN{printf "%.1f",k*100/t}')
 PL=""; [ "$n" -gt 1 ] && PL="${NL}   • Pourquoi $n processus : un programme moderne se découpe en plusieurs morceaux indépendants pour qu'un plantage d'un seul ne fasse pas tomber tout le reste ; le total ci-dessus les additionne."
 LIST="$LIST${NL}$i) $c${NL}   • Mémoire : $MEM ($PC % du total)${NL}   • Processeur : $cp % en moyenne depuis son lancement${NL}   • Processus : $n (propriétaire : $u)${NL}   • Rôle : $(desc "$c" "$u")$PL${NL}"
done <<< "$TOP"
TC=$(echo "$AGG" | sort -t'|' -k3 -nr | head -3 | awk -F'|' '$3>0{printf "   • %s : %s %%\n",$1,$3}')
[ -z "$TC" ] && TC="   • Aucun programme ne sollicite le processeur de façon notable."
TM=$(echo "$TOP" | head -1 | cut -d'|' -f4); TMP=$(awk -v k=${TM:-0} -v t=$MT 'BEGIN{printf "%d",k*100/t}'); TCP=$(echo "$AGG" | sort -t'|' -k3 -nr | head -1 | cut -d'|' -f3); TCP=${TCP%.*}
O="Un programme est une application que vous lancez (navigateur, lecteur de musique…). Un processus est un programme en train de fonctionner. Un même programme peut avoir plusieurs processus, d'où un nombre plus grand que ce que vous voyez à l'écran. Pourquoi cette page : savoir ce qui tourne permet de comprendre pourquoi l'ordinateur ralentit, ou de repérer un programme qui n'a rien à faire là.${NL}${NL}📊 Les $ALL processus en cours se répartissent ainsi${NL}   • $KT processus du noyau (le cœur de Debian) : internes au système, invisibles et normaux${NL}   • $MINE lancés par vous ($ME), directement ou via vos applications${NL}   • $SYS lancés par le système et ses services (root et autres comptes)${NL}   • Ils correspondent à $NP programmes différents${NL}      Pourquoi : un ordinateur Debian de bureau en a généralement entre 150 et 400 au repos : ce nombre est donc normal.${NL}${NL}🧟 Processus « zombies » : $ZO${NL}      Pourquoi : un zombie est un processus terminé dont le parent n'a pas encore noté la fin. Il ne consomme rien, mais s'il y en a beaucoup et qu'ils restent, un programme est mal programmé.${NL}${NL}🔥 Les 3 plus actifs en processeur en ce moment${NL}$TC${NL}      Pourquoi : cette valeur est la moyenne depuis le lancement du programme, pas l'instantané. Un programme qui tourne depuis longtemps paraît donc moins actif qu'il ne l'est.${NL}${NL}🧠 Les 20 programmes qui consomment le plus de mémoire${NL}      Pourquoi cette liste : la mémoire est la ressource qui manque en premier. Les chiffres sont approximatifs : les processus d'un même programme partagent une partie de la mémoire, donc le total peut être un peu surestimé.${NL}$LIST"
if [ "$TMP" -ge 40 ]; then R="Un programme occupe beaucoup de mémoire"; X="Le premier programme de la liste prend plus de 40 % de la mémoire. Si l'ordinateur ralentit, fermez-le (ou redémarrez-le) : c'est le premier suspect."
elif [ "${TCP:-0}" -ge 80 ]; then R="Un programme sollicite fortement le processeur"; X="Un programme travaille intensément. Normal pendant une vidéo ou une installation ; si cela dure sans que vous fassiez rien, fermez-le."
elif [ "$ZO" -gt 5 ]; then R="Plusieurs zombies détectés"; X="Ils ne gênent pas, mais s'ils s'accumulent, redémarrer le programme parent ou l'ordinateur les fait disparaître."
else R="Les programmes en cours sont normaux"; X="Aucun programme ne monopolise la mémoire ni le processeur, et le nombre de processus est habituel : rien à faire."; fi
NV=0; { [ "$TMP" -ge 40 ] || [ "${TCP:-0}" -ge 80 ] || [ "$ZO" -gt 5 ]; } && NV=1; dmp_niveau $NV
export X; j "Cette page montre tous les programmes qui tournent en ce moment, y compris ceux que vous ne voyez pas, et lesquels pèsent le plus lourd." "$O" "$R" "ps (DMP uniquement)"
