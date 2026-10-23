#!/bin/bash
source "$(dirname "$0")/lib.sh"
. /etc/os-release
case "$VERSION_ID" in 13) XU="Debian 13 est la version stable actuelle : elle reçoit les mises à jour de sécurité, vous êtes à jour.";; 12) XU="Debian 12 est la version précédente : elle reste suivie (support prolongé), mais prévoyez de passer à Debian 13.";; "") XU="Votre version n'est pas numérotée (test ou instable) : plus récente, mais moins stable.";; *) XU="Cette version de Debian est ancienne et n'est plus suivie pour la sécurité : une mise à niveau est recommandée, car les failles découvertes ne sont plus corrigées.";; esac
dmp_niveau 0
export X="$XU Pour un usage courant, Debian est parfaitement suffisante : navigateur, bureautique et multimédia fonctionnent sans souci."
j "Debian est le système d'exploitation : le grand chef d'orchestre qui fait fonctionner ensemble tout le matériel et tous vos programmes." "Vous utilisez $PRETTY_NAME. Son noyau (le cœur du système, qui parle directement au matériel) est en version $(uname -r), pour une architecture $(uname -m). Pourquoi c'est important : connaître sa version permet de savoir si elle est encore suivie et mise à jour. Debian est réputé pour sa stabilité." "Système reconnu" "/etc/os-release, uname"
