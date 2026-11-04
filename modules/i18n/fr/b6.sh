# Textes français du collecteur b6. Ne modifier que le texte.
T_COMP="$(tr_cle b6.comp)"
T_CMD="$(tr_cle b6.cmd)"
T_FICHE() {
case $RS in
exit-code) CA="$(tr_cle b6.cause.code ex=$EX)";;
signal|core-dump) CA="$(tr_cle b6.cause.plante)";;
timeout) CA="$(tr_cle b6.cause.pas_repondu)";;
start-limit-hit) CA="$(tr_cle b6.cause.renonce)";;
dependency) CA="$(tr_cle b6.cause.dependance)";;
resources) CA="$(tr_cle b6.cause.ressources)";;
*) CA="cause indiquée par le système : ${RS:-inconnue}";;
esac
case $u in
NetworkManager-wait-online*) RO="$(tr_cle b6.role.reseau_attente)";;
bluetooth*) RO="$(tr_cle b6.role.bluetooth)";;
cups*) RO="$(tr_cle b6.role.cups)";;
ModemManager*) RO="$(tr_cle b6.role.modem)";;
ssh*) RO="$(tr_cle b6.role.ssh)";;
apache2*|nginx*) RO="$(tr_cle b6.role.web)";;
smartmontools*|smartd*) RO="$(tr_cle b6.role.disques)";;
cron*) RO="$(tr_cle b6.role.cron)";;
*) RO="${D:-service du système}.";;
esac
[ -z "$LOG" ] && LOG="         (journal non lisible avec vos droits : tapez sudo journalctl -u $u)"
echo "${NL}❌ $u${NL}   • Rôle : $RO${NL}   • Cause de l'arrêt : $CA${NL}      Pourquoi : c'est le motif noté par le système au moment où le service s'est arrêté.${NL}   • Depuis : ${SI:-date inconnue}${NL}   • Derniers messages du journal :${NL}$LOG${NL}   • Que faire :${NL}      1) Essayer de le relancer : systemctl $sc restart $u${NL}      2) Si l'erreur revient, lire le journal complet : journalctl $sc -u $u${NL}      3) Si ce service ne vous sert pas, vous pouvez l'ignorer : un service en erreur qui n'est pas utilisé ne gêne pas le reste."
}
T_SVC() {
case $SK in active) e="✅ actif";; failed) e="❌ en erreur";; *) e="⚪ arrêté";; esac
IM="$IM${NL}   • $2 ($1) : $e${NL}      Pourquoi : $3"
}
T_SVCS() {
svc NetworkManager.service "Gestion du réseau" "c'est lui qui connecte l'ordinateur à internet."
svc systemd-timesyncd.service "Mise à l'heure" "il règle l'horloge sur internet ; une heure fausse bloque certains sites et les mises à jour."
svc cron.service "Tâches programmées" "il lance seul les nettoyages et sauvegardes planifiés."
svc ssh.service "Accès à distance" "il permet de se connecter à l'ordinateur depuis un autre appareil ; s'il est arrêté, personne ne peut entrer à distance, ce qui est plus sûr si vous n'en avez pas besoin."
svc cups.service "Impression" "il gère les imprimantes."
if [ $BT = 1 ]; then svc bluetooth.service "Bluetooth" "il gère les appareils sans fil."; else IM="$IM${NL}   • Bluetooth : ➖ non disponible${NL}      Pourquoi : cet ordinateur n'a pas de module Bluetooth, le service n'a donc rien à gérer. Son arrêt est normal et sans conséquence."; fi
if [ $WF = 1 ]; then svc wpa_supplicant.service "Wi-Fi" "il connecte l'ordinateur aux réseaux sans fil."; else IM="$IM${NL}   • Wi-Fi : ➖ non disponible${NL}      Pourquoi : cet ordinateur n'a pas de carte Wi-Fi, il se connecte uniquement par câble. C'est plus stable et sans conséquence."; fi
}
T_O() {
O="Un service est un petit programme invisible qui travaille en arrière-plan, comme le personnel d'un hôtel : on ne le voit pas, mais le réseau, l'impression, l'heure ou le son en dépendent. Pourquoi cette page : si un employé tombe malade, une fonction peut s'arrêter sans que vous compreniez pourquoi.${NL}${NL}📊 En ce moment${NL}   • Services en marche : $RUN${NL}   • Services lancés à chaque démarrage : $ENA${NL}   • Services en erreur : $T${NL}      Pourquoi : zéro est le résultat attendu, cela veut dire que personne ne manque à l'appel.${NL}${NL}🔧 Services importants${NL}$IM"
[ $T -gt 0 ] && O="$O${NL}${NL}🚨 Détail des services en erreur$NL$FI"
case $TL in
0) R="Tous les services fonctionnent"; X="Aucun service ne signale de problème : le réseau, l'heure, les tâches programmées et le reste travaillent normalement, donc rien à faire.";;
1) R="$(tr_cle b6.un.titre_t t=$T)"; X="$(tr_cle b6.un.texte)";;
*) R="$(tr_cle b6.plusieurs.titre_t t=$T)"; X="$(tr_cle b6.plusieurs.texte)";;
esac
}
