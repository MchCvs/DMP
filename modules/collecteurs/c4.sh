#!/bin/bash
if [ -z "$XDG_CURRENT_DESKTOP" ] || [ -z "$XDG_SESSION_TYPE" ]; then
  _E=$(systemctl --user show-environment 2>/dev/null)
  : "${XDG_CURRENT_DESKTOP:=$(echo "$_E" | sed -n 's/^XDG_CURRENT_DESKTOP=//p')}"
  : "${XDG_SESSION_TYPE:=$(echo "$_E" | sed -n 's/^XDG_SESSION_TYPE=//p')}"
  _S=$(loginctl list-sessions --no-legend 2>/dev/null | awk -v u="$(id -un)" '$3==u{print $1; exit}')
  : "${XDG_SESSION_TYPE:=$(loginctl show-session "$_S" -p Type --value 2>/dev/null)}"
fi
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C; . /etc/os-release
d=/sys/class/dmi/id; MOD="$(cat $d/sys_vendor 2>/dev/null) $(cat $d/product_name 2>/dev/null)"
case $(uname -m) in x86_64) AR="64 bits : le standard actuel, capable d'utiliser plus de 4 Go de mémoire";; i?86) AR="32 bits : ancien, limité à 4 Go de mémoire";; *) AR="$(uname -m)";; esac
O="🪪 Voici la carte d'identité de votre ordinateur.${NL}${NL}🖥️ Machine : ${MOD:-non lisible} (nom sur le réseau : $(hostname))${NL}   Pourquoi : permet de retrouver la documentation et les pilotes exacts.${NL}${NL}🐧 Système : $PRETTY_NAME${NL}   Pourquoi : détermine les logiciels disponibles et la durée des mises à jour de sécurité.${NL}${NL}🫀 Noyau (cœur du système) : $(uname -r)${NL}   Pourquoi : c'est lui qui parle au matériel ; sa version donne la compatibilité avec les composants récents.${NL}${NL}⚙️ Architecture : $AR${NL}   Pourquoi : détermine quels logiciels peuvent s'installer.${NL}${NL}🔧 Outils de DMP : Python $(python3 -V | cut -d' ' -f2), Bash ${BASH_VERSION%%(*}${NL}   Pourquoi : ce sont les outils qui permettent à DMP de lire et d'expliquer votre machine.${NL}${NL}🌍 Langue du système : ${LANG:-non définie}${NL}   Pourquoi : choisit la langue des menus, la date et l'orthographe des accents.${NL}${NL}🖼️ Session graphique : ${XDG_CURRENT_DESKTOP:-non détectée} (${XDG_SESSION_TYPE:-?})${NL}   Pourquoi : c'est le type de bureau, qui détermine l'apparence et le fonctionnement des fenêtres."
export X="Ces informations ne changent presque jamais : elles servent surtout quand on demande de l'aide, car elles permettent à quelqu'un de comprendre exactement votre configuration. Notez-les ou copiez-les."
j "Les informations techniques sont la carte d'identité de votre ordinateur : modèle, système, version. Pourquoi : quand on dépanne ou installe un logiciel, on commence toujours par ces informations." "$O" "Identité relevée" "uname, /etc/os-release, /sys/class/dmi/id"
