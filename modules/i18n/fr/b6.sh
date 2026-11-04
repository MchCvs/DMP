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
case $SK in active) e="$(tr_cle b6.etat.actif)";; failed) e="$(tr_cle b6.etat.erreur)";; *) e="$(tr_cle b6.etat.arrete)";; esac
IM="$IM${NL}   • $2 ($1) : $e${NL}      Pourquoi : $3"
}
T_SVCS() {
svc NetworkManager.service "$(tr_cle b6.svc.reseau.titre)" "$(tr_cle b6.svc.reseau.pourquoi)"
svc systemd-timesyncd.service "$(tr_cle b6.svc.heure.titre)" "$(tr_cle b6.svc.heure.pourquoi)"
svc cron.service "$(tr_cle b6.svc.cron.titre)" "$(tr_cle b6.svc.cron.pourquoi)"
svc ssh.service "$(tr_cle b6.svc.ssh.titre)" "$(tr_cle b6.svc.ssh.pourquoi)"
svc cups.service "$(tr_cle b6.svc.impression.titre)" "$(tr_cle b6.svc.impression.pourquoi)"
if [ $BT = 1 ]; then svc bluetooth.service "$(tr_cle b6.svc.bluetooth.titre)" "$(tr_cle b6.svc.bluetooth.pourquoi)"; else IM="$IM${NL}   • $(tr_cle b6.nondispo.bluetooth_titre)${NL}      Pourquoi : $(tr_cle b6.nondispo.bluetooth)"; fi
if [ $WF = 1 ]; then svc wpa_supplicant.service "$(tr_cle b6.svc.wifi.titre)" "$(tr_cle b6.svc.wifi.pourquoi)"; else IM="$IM${NL}   • $(tr_cle b6.nondispo.wifi_titre)${NL}      Pourquoi : $(tr_cle b6.nondispo.wifi)"; fi
}
T_O() {
O="$(tr_cle b6.intro)"
[ $T -gt 0 ] && O="$O${NL}${NL}🚨 $(tr_cle b6.detail_titre)$NL$FI"
case $TL in
0) R="Tous les services fonctionnent"; X="Aucun service ne signale de problème : le réseau, l'heure, les tâches programmées et le reste travaillent normalement, donc rien à faire.";;
1) R="$(tr_cle b6.un.titre_t t=$T)"; X="$(tr_cle b6.un.texte)";;
*) R="$(tr_cle b6.plusieurs.titre_t t=$T)"; X="$(tr_cle b6.plusieurs.texte)";;
esac
}
