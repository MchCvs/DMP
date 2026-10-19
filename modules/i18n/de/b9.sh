T_COMP="Diese Seite prüft, ob die Türen Ihres Computers gut verschlossen sind: Sicherheitsupdates, Firewall, offene Türen, Fernzugriff."
T_CMD="apt, ss, systemctl, last (DMP uniquement)"
T_NOHIST="   • Verlauf nicht verfügbar"
pd(){ case $1 in 3000) echo "Open WebUI: Chat-Oberfläche mit KI-Modellen, von Docker gestartet.";; 22) echo "Fernzugriff (SSH): erlaubt es, den Computer von einem anderen Gerät aus zu steuern.";; 631) echo "Drucken (CUPS).";; 80|443|8080) echo "Webserver.";; 8765) echo "Der DMP-Server, der diese Seiten anzeigt.";; 3306) echo "MySQL/MariaDB-Datenbank.";; 5432) echo "PostgreSQL-Datenbank.";; 25|587) echo "Interner Maildienst (hier Postfix): Er stellt die Nachrichten zu, die das System an sich selbst schickt, etwa Meldungen geplanter Aufgaben. Er sendet nichts ins Internet.";; 445|139) echo "Windows-Dateifreigabe (Samba).";; 53) echo "Lokales Verzeichnis der Webseitennamen (DNS).";; *) echo "Programm, das auf Verbindungen an dieser Nummer wartet.";; esac; }
T_PORTL() { PT="$PT${NL}🔒 Tür $p: intern im Computer${NL}   • Aufgabe: $(pd $p)${NL}   • Warum ungefährlich: Sie hört nur auf diesen Computer, niemand sonst kann sich damit verbinden.${NL}"; }
T_PORTE() { PT="$PT${NL}🚪 Tür $p: aus dem Netzwerk erreichbar${NL}   • Aufgabe: $(pd $p)${NL}   • Warum beobachten: Jedes Gerät in Ihrem Netzwerk kann versuchen, sich damit zu verbinden. Wenn Sie sie nicht brauchen, schließen Sie sie, indem Sie den Dienst anhalten.${NL}"; }
T_O() {
case $MC in
sec) MJ="⚠️ $SU Sicherheitsupdate(s) ausstehend (insgesamt $UP).${NL}   Warum: Ein Sicherheitsupdate schließt eine bereits bekannte Lücke; solange es nicht installiert ist, kann ein Angreifer die Lücke ausnutzen.";;
ord) MJ="🟡 Kein Sicherheitsupdate ausstehend, aber $UP gewöhnliche Update(s).${NL}   Warum: Sie bringen Korrekturen und Verbesserungen, weniger dringend.";;
*) MJ="✅ Alles ist aktuell.${NL}   Warum: Keine bekannte Lücke bleibt durch veraltete Software offen.";;
esac
case $AC in
old) MJ="$MJ${NL}   ⚠️ Die Update-Liste ist $AG Tage alt: Sie ist möglicherweise nicht mehr aktuell, führen Sie „sudo apt update“ aus.";;
recent) MJ="$MJ${NL}   Letzte Prüfung: vor $AG Tag(en).";;
esac
if [ $AUC = 1 ]; then AU="✅ Automatische Sicherheitsupdates: installiert.${NL}   Warum: Sie laufen von selbst, ohne dass Sie daran denken müssen."; else AU="⚪ Automatische Updates: nicht installiert.${NL}   Warum: Sie müssen sie also regelmäßig selbst ausführen (Paket unattended-upgrades zum Automatisieren)."; fi
if [ $RBC = 1 ]; then RB="⚠️ Ein Neustart ist nötig.${NL}   Warum: Ein Update (oft des Kernels) wird erst nach einem Neustart wirksam; ohne ihn bleibt die behobene Lücke offen."; else RB="✅ Kein Neustart ausstehend."; fi
if [ -n "$FW" ]; then PF="✅ Firewall aktiv ($FW).${NL}   Warum: Sie ist ein Türsteher am Eingang: Sie weist Verbindungen von außen ab, die Sie nicht erlaubt haben."; else PF="🟡 Keine Firewall erkannt (ufw, nftables, firewalld).${NL}   Warum: Ohne Türsteher ist jede offene Tür (siehe unten) aus Ihrem Netzwerk erreichbar. Ist keine Tür offen, bleibt das Risiko gering. Einfache Installation: sudo apt install ufw && sudo ufw enable."; fi
case $SSHC in
danger) SSH="🔴 Fernzugriff aktiv, direkte Anmeldung des Administratorkontos ERLAUBT.${NL}   Warum gefährlich: Jeder kennt den Namen „root“; ein Angreifer muss nur noch das Passwort finden. Setzen Sie PermitRootLogin no.";;
active) SSH="🟡 Fernzugriff (SSH) aktiv.${NL}   Warum: nützlich, wenn Sie ihn brauchen. Sonst deaktivieren Sie ihn: Eine geschlossene Tür lässt sich nicht aufbrechen.";;
*) SSH="✅ Fernzugriff (SSH) angehalten.${NL}   Warum: Niemand kann sich aus der Ferne mit diesem Computer verbinden.";;
esac
if [ $AAC = 1 ]; then AP="✅ AppArmor aktiv.${NL}   Warum: Es sperrt jedes Programm in einen Rahmen; ein gehacktes Programm kann den Rest nicht anfassen."; else AP="⚪ AppArmor inaktiv.${NL}   Warum: Das ist ein zusätzlicher Schutz, der nicht genutzt wird; das bedeutet kein unmittelbares Risiko."; fi
O="Sicherheit ist wie das Abschließen des Hauses: Man prüft die Schlösser (Updates), den Türsteher (Firewall), die offen gelassenen Türen (Ports) und wer zuletzt hereingekommen ist. Warum diese Seite: Die meisten Einbrüche laufen über eine bereits behobene, aber nicht installierte Lücke oder über eine unnötig offene Tür.${NL}${NL}🛠️ Updates${NL}$MJ${NL}$AU${NL}$RB${NL}${NL}🧱 Firewall${NL}$PF${NL}${NL}🚪 Lauschende Türen (Ports): $EXP aus dem Netzwerk erreichbar, $LOC intern${NL}   Warum: Ein „Port“ ist eine nummerierte Tür, über die ein Programm Verbindungen entgegennimmt. Je mehr Türen von außen erreichbar sind, desto mehr mögliche Einstiegspunkte gibt es.$PT${NL}🔑 Fernzugriff${NL}$SSH${NL}${NL}🛡️ Schutz der Programme${NL}$AP${NL}${NL}👤 Die letzten 5 Anmeldungen an diesem Computer${NL}   Warum: um eine Anmeldung zu erkennen, die Sie nicht kennen.${NL}${LG:-$T_NOHIST}"
case $SC in
0) R="System gut geschützt"; X="Kein Update ausstehend, keine unnötig offene Tür, nichts zu melden: Die wichtigsten Eingänge sind geschlossen. Behalten Sie die Gewohnheit bei, jede Woche Updates zu installieren.";;
1) R="Geschützt, einige Punkte zu verbessern"; X="Nichts Schlimmes: Das System ist nicht in unmittelbarer Gefahr, aber einige Punkte oben (gewöhnliche Updates, fehlende Firewall, erreichbare Tür, Neustart) würden den Schutz robuster machen. Gehen Sie sie in der angezeigten Reihenfolge an.";;
*) R="Lücken, die schnell zu schließen sind"; X="Ein ernster Punkt wird gemeldet (ausstehendes Sicherheitsupdate, zu viele offene Türen oder Administrator-Fernzugriff). Beheben Sie ihn zuerst: sudo apt update && sudo apt upgrade.";;
esac
}
