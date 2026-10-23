#!/bin/bash
source "$(dirname "$0")/lib.sh"; NL=$'\n'; export LC_ALL=C
L=$(apt list --upgradable 2>/dev/null | tail -n +2); UP=$(echo "$L" | grep -c .); SU=$(echo "$L" | grep -ci security)
ST=/var/lib/apt/periodic/update-success-stamp; [ -f $ST ] && AG=$(( ($(date +%s)-$(stat -c %Y $ST))/86400 )) || AG=-1
LST=$( (echo "$L" | grep -i security; echo "$L" | grep -vi security) | grep . | head -15 | awk '{split($1,a,"/");o=$NF;sub(/\]/,"",o);s=($0~/[Ss]ecurity/)?"🔴 sécurité":"🔵 ordinaire";printf "   • %s : %s → %s (%s)\n",a[1],o,$2,s}')
if [ $UP -eq 0 ]; then O="✅ Aucune mise à jour en attente : tous vos logiciels sont à la dernière version connue.${NL}   Pourquoi : aucune faille déjà corrigée n'est laissée ouverte."
else O="📦 $UP mise(s) à jour en attente, dont $SU de sécurité.${NL}${NL}Liste (les plus importantes d'abord, 15 maximum) :${NL}$LST${NL}${NL}🔴 Sécurité : corrige une faille connue, qu'un pirate peut utiliser tant qu'elle n'est pas installée.${NL}🔵 Ordinaire : corrige un défaut ou apporte une amélioration, moins urgent.${NL}   Lecture d'une ligne : nom du logiciel : version actuelle → version disponible."; fi
[ $AG -ge 0 ] && O="$O${NL}${NL}🕒 Dernière vérification des nouveautés : il y a $AG jour(s).${NL}   Pourquoi : cette liste n'est fiable que si elle est récente. Au-delà de 7 jours, lancez d'abord « sudo apt update »."
O="$O${NL}${NL}🛠️ Comment installer (à taper dans un terminal)${NL}   1) sudo apt update : met à jour la liste des nouveautés (n'installe rien).${NL}   2) sudo apt upgrade : installe les mises à jour. Debian ne supprime rien sans vous le dire.${NL}   Pourquoi en deux temps : on regarde d'abord ce qui existe, puis on décide d'installer."
if [ $SU -gt 0 ]; then R="À faire rapidement"; X="$SU mise(s) à jour de sécurité attendent : tant qu'elles ne sont pas installées, des failles connues restent ouvertes. Comme un vaccin, plus tôt c'est fait, mieux vous êtes protégé. Lancez les deux commandes ci-dessus."
elif [ $UP -gt 0 ]; then R="À faire, sans urgence"; X="Aucune faille de sécurité en attente, seulement des améliorations. Installez-les cette semaine : cela garde le système cohérent et évite l'accumulation."
else R="Système à jour"; X="Rien à faire. Gardez l'habitude de vérifier chaque semaine, car de nouvelles failles sont corrigées régulièrement."; fi
NV=0; [ $UP -gt 0 ] && NV=1; [ $SU -gt 0 ] && NV=2; dmp_niveau $NV
export X; j "Les mises à jour sont des vaccins pour votre ordinateur : chaque fois qu'une faille ou un défaut est découvert dans un logiciel, ses auteurs publient une version corrigée. Pourquoi les installer : un logiciel non mis à jour garde ses failles, et ce sont elles que les pirates et virus exploitent." "$O" "$R" "apt list --upgradable (DMP uniquement)"
