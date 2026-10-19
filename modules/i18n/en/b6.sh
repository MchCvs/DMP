T_COMP="This page checks that the small invisible programs that keep your computer running are all working properly."
T_CMD="systemctl, journalctl (DMP uniquement)"
T_FICHE() {
case $RS in
exit-code) CA="the program stopped and reported an error (code $EX)";;
signal|core-dump) CA="the program was abruptly interrupted, it crashed";;
timeout) CA="the program did not respond in time at startup or shutdown";;
start-limit-hit) CA="the program crashed several times in a row: the system gave up restarting it";;
dependency) CA="it depends on another service that did not start";;
resources) CA="the system did not have enough resources to launch it";;
*) CA="cause reported by the system: ${RS:-unknown}";;
esac
case $u in
NetworkManager-wait-online*) RO="holds up startup until the network is ready. Often in error with no consequence if the network arrives a little later.";;
bluetooth*) RO="handles Bluetooth (headset, mouse, wireless gamepad). In error: Bluetooth will not work, the rest will.";;
cups*) RO="handles printing. In error: printing is impossible.";;
ModemManager*) RO="handles 3G/4G keys and modems. Irrelevant if you have none.";;
ssh*) RO="allows remote connection to this computer. In error: nobody can connect to it remotely.";;
apache2*|nginx*) RO="local web server. In error: the sites hosted here are unreachable.";;
smartmontools*|smartd*) RO="monitors disk health. In error: failure alerts will no longer be sent.";;
cron*) RO="runs scheduled tasks (backups, cleanups). In error: they no longer run.";;
*) RO="${D:-system service}.";;
esac
[ -z "$LOG" ] && LOG="         (journal not readable with your rights: type sudo journalctl -u $u)"
echo "${NL}❌ $u${NL}   • Role: $RO${NL}   • Cause of the stop: $CA${NL}      Why: this is the reason recorded by the system when the service stopped.${NL}   • Since: ${SI:-unknown date}${NL}   • Latest journal messages:${NL}$LOG${NL}   • What to do:${NL}      1) Try restarting it: systemctl $sc restart $u${NL}      2) If the error comes back, read the full journal: journalctl $sc -u $u${NL}      3) If you do not use this service, you can ignore it: a failed service that is not used does not bother the rest."
}
T_SVC() {
case $SK in active) e="✅ active";; failed) e="❌ in error";; *) e="⚪ stopped";; esac
IM="$IM${NL}   • $2 ($1): $e${NL}      Why: $3"
}
T_SVCS() {
svc NetworkManager.service "Network management" "it is what connects the computer to the internet."
svc systemd-timesyncd.service "Time sync" "it sets the clock from the internet; a wrong time blocks some sites and updates."
svc cron.service "Scheduled tasks" "it runs planned cleanups and backups on its own."
svc ssh.service "Remote access" "it lets you connect to the computer from another device; if stopped, nobody can get in remotely, which is safer if you do not need it."
svc cups.service "Printing" "it handles printers."
if [ $BT = 1 ]; then svc bluetooth.service "Bluetooth" "it handles wireless devices."; else IM="$IM${NL}   • Bluetooth: ➖ not available${NL}      Why: this computer has no Bluetooth module, so the service has nothing to handle. Its being stopped is normal and harmless."; fi
if [ $WF = 1 ]; then svc wpa_supplicant.service "Wi-Fi" "it connects the computer to wireless networks."; else IM="$IM${NL}   • Wi-Fi: ➖ not available${NL}      Why: this computer has no Wi-Fi card, it connects by cable only. This is more stable and harmless."; fi
}
T_O() {
O="A service is a small invisible program that works in the background, like the staff of a hotel: you do not see it, but the network, printing, the time or the sound depend on it. Why this page: if an employee falls ill, a function may stop without you understanding why.${NL}${NL}📊 Right now${NL}   • Services running: $RUN${NL}   • Services started at every boot: $ENA${NL}   • Services in error: $T${NL}      Why: zero is the expected result, it means nobody is missing from the roll call.${NL}${NL}🔧 Important services${NL}$IM"
[ $T -gt 0 ] && O="$O${NL}${NL}🚨 Details of the services in error$NL$FI"
case $TL in
0) R="All services are working"; X="No service reports a problem: the network, the time, scheduled tasks and the rest work normally, so there is nothing to do.";;
1) R="$T service(s) in error: worth a look, not urgent"; X="One or two services in error do not usually block the computer, because each service is independent. Read the sheets above: if the role does not concern you (for example Bluetooth with no device), you can ignore it; otherwise, try restarting it.";;
*) R="$T services in error: to be dealt with"; X="Several services in error at the same time may point to a common problem (network, full disk, interrupted update). Start with the Disk (B4) and Network (B5) pages, then restart the listed services.";;
esac
}
