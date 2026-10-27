T_COMP="Diese Seite prüft, ob die kleinen unsichtbaren Programme, die Ihren Computer am Laufen halten, alle richtig arbeiten."
T_CMD="systemctl, journalctl (DMP uniquement)"
T_FICHE() {
case $RS in
exit-code) CA="das Programm hat sich beendet und einen Fehler gemeldet (Code $EX)";;
signal|core-dump) CA="das Programm wurde abrupt unterbrochen, es ist abgestürzt";;
timeout) CA="das Programm hat beim Starten oder Beenden nicht rechtzeitig geantwortet";;
start-limit-hit) CA="das Programm ist mehrmals hintereinander abgestürzt: Das System hat es aufgegeben, es neu zu starten";;
dependency) CA="es hängt von einem anderen Dienst ab, der nicht gestartet ist";;
resources) CA="das System hatte nicht genug Ressourcen, um es zu starten";;
*) CA="vom System angegebene Ursache: ${RS:-unbekannt}";;
esac
case $u in
NetworkManager-wait-online*) RO="lässt den Start warten, bis das Netzwerk bereit ist. Oft ohne Folgen im Fehlerzustand, wenn das Netzwerk etwas später kommt.";;
bluetooth*) RO="verwaltet Bluetooth (Headset, Maus, kabelloses Gamepad). Im Fehlerzustand: Bluetooth funktioniert nicht, der Rest schon.";;
cups*) RO="verwaltet das Drucken. Im Fehlerzustand: Drucken ist nicht möglich.";;
ModemManager*) RO="verwaltet 3G/4G-Sticks und -Modems. Belanglos, wenn Sie keine haben.";;
ssh*) RO="erlaubt die Verbindung zu diesem Computer aus der Ferne. Im Fehlerzustand: Niemand kann sich aus der Ferne verbinden.";;
apache2*|nginx*) RO="lokaler Webserver. Im Fehlerzustand: Die hier gehosteten Seiten sind nicht erreichbar.";;
smartmontools*|smartd*) RO="überwacht den Zustand der Datenträger. Im Fehlerzustand: Ausfallwarnungen werden nicht mehr gesendet.";;
cron*) RO="startet geplante Aufgaben (Sicherungen, Aufräumarbeiten). Im Fehlerzustand: Sie werden nicht mehr ausgeführt.";;
*) RO="${D:-Systemdienst}.";;
esac
[ -z "$LOG" ] && LOG="         (Journal mit Ihren Rechten nicht lesbar: geben Sie sudo journalctl -u $u ein)"
echo "${NL}❌ $u${NL}   • Aufgabe: $RO${NL}   • Ursache des Stopps: $CA${NL}      Warum: Das ist der Grund, den das System notiert hat, als der Dienst anhielt.${NL}   • Seit: ${SI:-unbekanntes Datum}${NL}   • Letzte Journal-Meldungen:${NL}$LOG${NL}   • Was tun:${NL}      1) Versuchen, ihn neu zu starten: systemctl $sc restart $u${NL}      2) Wenn der Fehler wiederkehrt, das vollständige Journal lesen: journalctl $sc -u $u${NL}      3) Wenn Sie diesen Dienst nicht brauchen, können Sie ihn ignorieren: Ein fehlerhafter Dienst, der nicht genutzt wird, stört den Rest nicht."
}
T_SVC() {
case $SK in active) e="✅ aktiv";; failed) e="❌ fehlerhaft";; *) e="⚪ angehalten";; esac
IM="$IM${NL}   • $2 ($1): $e${NL}      Warum: $3"
}
T_SVCS() {
svc NetworkManager.service "Netzwerkverwaltung" "Er verbindet den Computer mit dem Internet."
svc systemd-timesyncd.service "Zeitabgleich" "Er stellt die Uhr über das Internet; eine falsche Uhrzeit blockiert manche Webseiten und Updates."
svc cron.service "Geplante Aufgaben" "Er startet geplante Aufräumarbeiten und Sicherungen von selbst."
svc ssh.service "Fernzugriff" "Er erlaubt es, sich von einem anderen Gerät mit dem Computer zu verbinden; ist er angehalten, kann niemand aus der Ferne eindringen, was sicherer ist, wenn Sie ihn nicht brauchen."
svc cups.service "Drucken" "Er verwaltet die Drucker."
if [ $BT = 1 ]; then svc bluetooth.service "Bluetooth" "Er verwaltet kabellose Geräte."; else IM="$IM${NL}   • Bluetooth: ➖ nicht verfügbar${NL}      Warum: Dieser Computer hat kein Bluetooth-Modul, der Dienst hat also nichts zu verwalten. Dass er angehalten ist, ist normal und ohne Folgen."; fi
if [ $WF = 1 ]; then svc wpa_supplicant.service "WLAN" "Er verbindet den Computer mit drahtlosen Netzwerken."; else IM="$IM${NL}   • WLAN: ➖ nicht verfügbar${NL}      Warum: Dieser Computer hat keine WLAN-Karte, er verbindet sich nur per Kabel. Das ist stabiler und ohne Folgen."; fi
}
T_O() {
O="Ein Dienst ist ein kleines unsichtbares Programm, das im Hintergrund arbeitet, wie das Personal eines Hotels: Man sieht es nicht, aber Netzwerk, Drucken, die Uhrzeit oder der Ton hängen davon ab. Warum diese Seite: Wenn ein Mitarbeiter krank wird, kann eine Funktion aussetzen, ohne dass Sie verstehen, warum.${NL}${NL}📊 Im Moment${NL}   • Laufende Dienste: $RUN${NL}   • Bei jedem Start gestartete Dienste: $ENA${NL}   • Dienste mit Fehler: $T${NL}      Warum: Null ist das erwartete Ergebnis, es bedeutet, dass niemand beim Appell fehlt.${NL}${NL}🔧 Wichtige Dienste${NL}$IM"
[ $T -gt 0 ] && O="$O${NL}${NL}🚨 Details der fehlerhaften Dienste$NL$FI"
case $TL in
0) R="Alle Dienste funktionieren"; X="Kein Dienst meldet ein Problem: Netzwerk, Uhrzeit, geplante Aufgaben und der Rest arbeiten normal, also ist nichts zu tun.";;
1) R="$T Dienst(e) mit Fehler: ansehen, nicht dringend"; X="Ein oder zwei fehlerhafte Dienste blockieren den Computer in der Regel nicht, da jeder Dienst unabhängig ist. Lesen Sie die Karteikarten oben: Wenn die Aufgabe Sie nicht betrifft (zum Beispiel Bluetooth ohne Gerät), können Sie sie ignorieren; versuchen Sie sonst, ihn neu zu starten.";;
*) R="$T Dienste mit Fehler: zu beheben"; X="Mehrere fehlerhafte Dienste gleichzeitig können auf ein gemeinsames Problem hindeuten (Netzwerk, voller Datenträger, unterbrochenes Update). Beginnen Sie mit den Seiten Datenträger (B4) und Netzwerk (B5) und starten Sie dann die aufgeführten Dienste neu.";;
esac
}
