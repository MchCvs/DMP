T_COMP="Diese Seite zeigt alle Programme, die gerade laufen, auch die, die Sie nicht sehen, und welche am schwersten wiegen."
T_CMD="ps (DMP uniquement)"
T_GB="GB"; T_MB="MB"
T_TCFMT='   • %s: %s %%\n'
T_TCNONE="   • Kein Programm beansprucht den Prozessor nennenswert."
desc(){ case "$1" in
 systemd) echo "Der Dirigent des Systems: Er startet und überwacht alle anderen Dienste. Ohne ihn startet nichts.";;
 systemd-*|dbus-daemon|dbus-broker*) echo "Interner Dienst, der es Programmen ermöglicht, miteinander zu sprechen und das System zu verwalten (Journal, Uhrzeit, Verbindungen).";;
 NetworkManager|wpa_supplicant) echo "Verwaltet die Verbindung zum Netzwerk und zum Internet.";;
 sshd|ssh) echo "Ermöglicht die Verbindung zum Computer aus der Ferne.";;
 cron|cron.service) echo "Startet geplante Aufgaben (Aufräumarbeiten, Sicherungen).";;
 Xorg|Xwayland|gnome-shell|plasmashell|kwin*|xfwm4|xfdesktop|mutter) echo "Zeichnet Ihren Desktop, die Fenster und den Bildschirm. Ohne ihn sehen Sie nichts.";;
 gdm*|lightdm|sddm) echo "Zeigt den Anmeldebildschirm an und öffnet Ihre Sitzung.";;
 firefox*|chrome*|chromium*|brave*) echo "Ihr Webbrowser: Er zeigt Webseiten an.";;
 "Web Content"|WebExtensions|"Isolated Web Co"|"Privileged Cont"|RDD*|"Socket Process") echo "Teile des Browsers: Jeder Tab oder jede Erweiterung läuft in einem eigenen Prozess.";;
 thunderbird*) echo "Ihr Mailprogramm (E-Mails).";;
 soffice*|libreoffice*) echo "LibreOffice: Textverarbeitung, Tabellenkalkulation, Präsentationen.";;
 vlc|mpv|totem) echo "Wiedergabe von Videos und Musik.";;
 pipewire*|wireplumber|pulseaudio) echo "Verwaltet den Ton: Lautsprecher, Mikrofon, Headset.";;
 python*|node|java) echo "Ein in einer Skriptsprache geschriebenes Programm (oder ein Entwicklungswerkzeug). Hier kann es der DMP-Server selbst sein.";;
 bash|sh|zsh|dash|fish) echo "Ein Terminal (das Fenster, in dem man Befehle eintippt) oder das Skript, das darin läuft.";;
 cupsd|cups-browsed) echo "Verwaltet das Drucken.";;
 bluetoothd) echo "Verwaltet Bluetooth.";;
 avahi-daemon) echo "Hilft dem Computer, Drucker und Geräte im lokalen Netzwerk zu entdecken.";;
 rsyslogd) echo "Führt das Journal der Systemereignisse (nützlich, um ein Problem zu verstehen).";;
 polkitd|udisksd|upowerd|accounts-daemon|colord) echo "Systemdienst: verwaltet Berechtigungen, angeschlossene Datenträger, Energie oder Bildschirmprofile.";;
 gvfs*|tracker*|localsearch*) echo "Desktop-Dienst: Zugriff auf Dateien (Netzwerk, USB-Sticks) und Suche in Ihren Dokumenten.";;
 code|codium) echo "Der Code-Editor Visual Studio Code.";;
 claude*) echo "Der Assistent Claude Code, der im Terminal verwendet wird.";;
 *) if [ "$2" = root ]; then echo "Systemprogramm, vom Administrator (root) gestartet. Es arbeitet im Hintergrund für einen Debian-Dienst."; else echo "Programm, das Sie oder eine Ihrer Anwendungen gestartet haben."; fi;;
 esac; }
T_ITEM() {
PL=""; [ "$n" -gt 1 ] && PL="${NL}   • Warum $n Prozesse: Ein modernes Programm teilt sich in mehrere unabhängige Teile auf, damit der Absturz eines einzelnen nicht alles andere mitreißt; die Summe oben addiert sie."
LIST="$LIST${NL}$i) $c${NL}   • Arbeitsspeicher: $MEM ($PC % der Gesamtmenge)${NL}   • Prozessor: $cp % im Durchschnitt seit dem Start${NL}   • Prozesse: $n (Besitzer: $u)${NL}   • Aufgabe: $(desc "$c" "$u")$PL${NL}"
}
T_O() {
O="Ein Programm ist eine Anwendung, die Sie starten (Browser, Musikplayer…). Ein Prozess ist ein Programm, das gerade läuft. Ein Programm kann mehrere Prozesse haben, daher ist die Zahl größer als das, was Sie auf dem Bildschirm sehen. Warum diese Seite: Wenn Sie wissen, was läuft, verstehen Sie, warum der Computer langsamer wird, oder erkennen ein Programm, das dort nichts zu suchen hat.${NL}${NL}📊 Die $ALL laufenden Prozesse verteilen sich so${NL}   • $KT Kernel-Prozesse (der Kern von Debian): intern im System, unsichtbar und normal${NL}   • $MINE von Ihnen gestartet ($ME), direkt oder über Ihre Anwendungen${NL}   • $SYS vom System und seinen Diensten gestartet (root und andere Konten)${NL}   • Sie entsprechen $NP verschiedenen Programmen${NL}      Warum: Ein Debian-Desktop-Computer hat im Ruhezustand in der Regel zwischen 150 und 400: Diese Zahl ist also normal.${NL}${NL}🧟 „Zombie“-Prozesse: $ZO${NL}      Warum: Ein Zombie ist ein beendeter Prozess, dessen Elternprozess sein Ende noch nicht vermerkt hat. Er verbraucht nichts, aber wenn es viele gibt und sie bleiben, ist ein Programm schlecht programmiert.${NL}${NL}🔥 Die 3 aktivsten Prozessor-Nutzer im Moment${NL}$TC${NL}      Warum: Dieser Wert ist der Durchschnitt seit dem Start des Programms, nicht der Momentanwert. Ein Programm, das schon lange läuft, wirkt daher weniger aktiv, als es ist.${NL}${NL}🧠 Die 20 Programme mit dem höchsten Speicherverbrauch${NL}      Warum diese Liste: Der Arbeitsspeicher ist die Ressource, die zuerst knapp wird. Die Zahlen sind ungefähr: Die Prozesse eines Programms teilen sich einen Teil des Speichers, daher kann die Summe etwas zu hoch sein.${NL}$LIST"
case $RL in
mem) R="Ein Programm belegt viel Arbeitsspeicher"; X="Das erste Programm der Liste belegt mehr als 40 % des Arbeitsspeichers. Wenn der Computer langsamer wird, schließen Sie es (oder starten Sie es neu): Es ist der Hauptverdächtige.";;
cpu) R="Ein Programm beansprucht den Prozessor stark"; X="Ein Programm arbeitet intensiv. Normal bei einem Video oder einer Installation; wenn es anhält, obwohl Sie nichts tun, schließen Sie es.";;
zomb) R="Mehrere Zombies erkannt"; X="Sie stören nicht, aber wenn sie sich ansammeln, lässt ein Neustart des Elternprogramms oder des Computers sie verschwinden.";;
*) R="Die laufenden Programme sind normal"; X="Kein Programm beansprucht den Arbeitsspeicher oder den Prozessor allein, und die Zahl der Prozesse ist üblich: nichts zu tun.";;
esac
}
