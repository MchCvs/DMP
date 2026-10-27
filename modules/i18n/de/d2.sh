# Deutsche Texte des Collectors d2. Nur den Text ändern.
T_COMP="Entfernen heißt, Software zu deinstallieren, die Sie nicht mehr brauchen. Diese Seite zeigt Ihnen die größten, wofür sie dienen und wie Sie sie gefahrlos entfernen. Warum: Ein entlasteter Computer startet schneller und behält Platz für das Wesentliche."
T_R="Kein Entfernen nötig"
T_CMD="apt-mark showmanual, dpkg-query"
T_MO="MB"
T_ROLE="Aufgabe:"
T_CAN="Kann es entfernt werden?"
T_X="DMP entfernt nichts: Diese Seite zeigt Ihnen was, warum und wie, die Entscheidung bleibt bei Ihnen. Einfache Regel für Einsteiger: Entfernen Sie hier nichts. Einen Namen nicht zu kennen heißt nicht, dass er unnötig ist: Die wichtigsten Teile des Systems sind gerade die, die man nie sieht. Entfernen Sie nur Software, deren Aufgabe Sie verstehen (zum Beispiel ein Spiel oder eine von Ihnen installierte Anwendung) UND die Sie ganz sicher nicht mehr brauchen."
T_PKG(){ case "$1" in
 linux-image*) echo "Der Linux-Kernel: das Herz von Debian. Er verbindet die Hardware (Bildschirm, Festplatte, Tastatur) mit den Programmen. Ohne ihn startet der Computer nicht.";;
 linux-headers*|linux-kbuild*|linux-compiler*) echo "Dateien, mit denen Treiber für den Kernel gebaut werden (zum Beispiel für eine Grafikkarte). Vor allem für fortgeschrittene Nutzer nützlich.";;
 firefox*) echo "Firefox: der Webbrowser, der Internetseiten anzeigt.";;
 chromium*|google-chrome*|brave*) echo "Ein Webbrowser: Er zeigt Internetseiten an.";;
 thunderbird*) echo "Thunderbird: das E-Mail-Programm.";;
 libreoffice*) echo "LibreOffice: das Büropaket (Textverarbeitung, Tabellenkalkulation, Präsentationen), die freie Alternative zu Word und Excel.";;
 gimp*) echo "GIMP: Bearbeitung von Fotos und Bildern, die freie Alternative zu Photoshop.";;
 inkscape*) echo "Inkscape: Vektorgrafik (Logos, Illustrationen, die in jeder Größe scharf bleiben).";;
 vlc*|mpv*) echo "Video- und Musikplayer, der fast alle Formate abspielt.";;
 audacity*) echo "Audacity: Aufnahme und Bearbeitung von Tönen.";;
 kdenlive*|openshot*|shotcut*) echo "Programm zum Videoschnitt.";;
 blender*) echo "Blender: Erstellung von 3D-Bildern und -Filmen.";;
 steam*) echo "Steam: Shop und Startprogramm für Videospiele.";;
 wine*) echo "Wine: erlaubt es, einige Windows-Programme unter Linux zu starten.";;
 code|codium) echo "Visual Studio Code: ein Editor zum Schreiben von Programmen.";;
 nodejs|npm) echo "Node.js: eine Umgebung, um in JavaScript geschriebene Programme auszuführen.";;
 openjdk*|default-jre*|default-jdk*) echo "Java: nötig, um manche in Java geschriebene Programme zu starten.";;
 docker*|podman*) echo "Verwaltung von „Containern“: abgeschottete Behälter, in denen Software läuft, ohne den Rest des Systems anzutasten.";;
 virtualbox*|qemu*) echo "Erstellung virtueller Computer: Ein anderes System läuft in einem Fenster.";;
 texlive*) echo "TeX Live: Satz wissenschaftlicher Dokumente und Bücher (LaTeX). Sehr umfangreich.";;
 nvidia*|xserver-xorg-video*) echo "Treiber der Grafikkarte: Er ermöglicht es, sie mit voller Leistung zu nutzen.";;
 firmware-*|amd64-microcode|intel-microcode) echo "Firmware: ein kleines, in eine Komponente (WLAN, Grafikkarte, Prozessor) eingebautes Programm, damit sie richtig funktioniert.";;
 task-*) echo "Ein Bündel von Software, das auf einmal installiert wird (Desktop, Sprache ...). Wird es entfernt, bleibt die Software erhalten, nur die Bündelung verschwindet.";;
 gnome-*|gnome|kde-*|plasma-*|xfce4*) echo "Ein Teil der grafischen Oberfläche: Fenster, Menüs, Symbole, Einstellungen.";;
 grub*) echo "GRUB: das Programm, das Debian beim Einschalten des Computers startet.";;
 libc6*|systemd|systemd-*) echo "Ein Grundbaustein des Systems, für fast alle Programme unverzichtbar.";;
 python3*|python3-*) echo "Python: eine Programmiersprache. Mehrere Debian-Werkzeuge verwenden sie.";;
 gcc*|g++*|build-essential|make|cmake) echo "Werkzeuge, um Software aus ihrem Quellcode zu bauen. Nutzlos, wenn Sie nicht programmieren.";;
 git|git-*) echo "Git: Versionsverwaltung für ein Programmierprojekt.";;
 mariadb*|mysql*|postgresql*) echo "Ein Datenbankverwaltungssystem: Es speichert große Informationsmengen geordnet.";;
 apache2*|nginx*) echo "Ein Webserver: Er stellt Internetseiten im Netzwerk bereit.";;
 cups*) echo "Verwaltung des Druckens.";;
 ufw) echo "ufw: die Firewall; sie blockiert Verbindungen von außen, die Sie nicht erlaubt haben.";;
 smartmontools) echo "Überwacht den Zustand der Datenträger (wird von Seite B4 verwendet).";;
 locales*|keyboard-configuration|console-setup*) echo "Einstellungen für Sprache und Tastatur.";;
 esac; }
T_SEC(){ case "$1" in
 libs|libdevel|oldlibs) echo "Eine Bibliothek: ein Stück Code, das von mehreren Programmen gemeinsam genutzt wird, wie ein Kochbuch, in dem mehrere Köche nachschlagen. Sie ist installiert, weil ein anderes Programm sie braucht.";;
 python|perl|interpreters) echo "Ein Modul für eine Programmiersprache, von dem andere Programme abhängen.";;
 kernel) echo "Ein Bestandteil des Kernels (des Herzens des Systems).";;
 fonts) echo "Schriftarten: Sie bestimmen das Aussehen der Buchstaben auf dem Bildschirm und in Dokumenten.";;
 doc) echo "Dokumentation: Handbücher und Hilfen.";;
 devel|vcs) echo "Ein Werkzeug zum Programmieren. Nutzlos, wenn Sie keine Software entwickeln.";;
 games) echo "Ein Spiel.";;
 graphics|photo) echo "Ein Programm für Fotos, Zeichnungen oder Bilder.";;
 video|sound|libs/multimedia) echo "Ein Programm für Video oder Ton.";;
 web|net|mail|httpd) echo "Ein Programm für das Internet oder das Netzwerk.";;
 admin|utils|shells|misc) echo "Ein Wartungswerkzeug für das System oder ein Hilfsprogramm.";;
 x11|gnome|kde|xfce) echo "Ein Teil der grafischen Oberfläche: Fenster, Menüs, Symbole.";;
 editors|text) echo "Ein Editor oder ein Textwerkzeug.";;
 science|math) echo "Ein wissenschaftliches Programm oder Rechenprogramm.";;
 database) echo "Ein Datenbankverwaltungssystem.";;
 *) echo "Ein auf Ihrem Computer installiertes Programm (Kategorie: $1). Die offizielle Beschreibung erhalten Sie mit „apt show Programmname“ (auf Englisch).";;
 esac; }
T_SU(){ local p="$1" pri="$2"; case "$p" in
 linux-image*) echo "⛔ NEIN: Ohne Kernel startet der Computer nicht. Debian behält den alten als Reserve, lassen Sie es gewähren.";;
 grub*) echo "⛔ NEIN: GRUB startet Debian beim Einschalten. Wird es entfernt, kann der Computer womöglich nicht mehr starten und künftige Kernel-Aktualisierungen scheitern.";;
 intel-microcode|amd64-microcode) echo "⛔ NEIN: Es behebt beim Start Sicherheitslücken des Prozessors (Typ Spectre). Ohne es startet der Computer, aber diese Lücken bleiben offen.";;
 firmware-*) echo "⛔ NEIN: Es ist das interne Programm, das eine Komponente zum Funktionieren braucht (Grafik, WLAN ...). Ohne es: eingeschränktes oder schwarzes Bild, unbrauchbare Komponente.";;
 locales*) echo "⛔ NEIN: Es steuert Sprache, Akzente und Datumsangaben. Ohne es: Fehlermeldungen, defekte Zeichen, und viele Programme funktionieren nicht mehr.";;
 systemd*|libc6*|apt|dpkg|bash|coreutils|sudo|initramfs-tools*|xserver*|network-manager*|tzdata|ca-certificates|keyboard-configuration|console-setup*|ufw) echo "⛔ NEIN: Grundbaustein des Systems, andere Software hängt davon ab. Wird er entfernt, kann der Computer womöglich nicht mehr funktionieren.";;
 *) case $pri in required|important) echo "⛔ NEIN: Das System braucht es, um zu funktionieren.";; *) echo "🟠 Lassen Sie es, außer Sie wissen genau, wozu es dient, und sind sicher, es nicht zu brauchen. Ein unbekannter Name ist KEIN Grund zum Entfernen: Viele nützliche Programme sind unsichtbar.";; esac;;
 esac; }
T_O() {
O="🗑️ Software entfernen heißt, sie zu deinstallieren, um Platz freizugeben und das System zu entlasten.${NL}Warum: Unnötige Software belegt Platz, erhält eventuell grundlos Aktualisierungen und erhöht das Risiko von Sicherheitslücken.${NL}${NL}📖 Die 3 Arten, Software zu entfernen${NL}   • apt remove Name: entfernt die Software, behält aber ihre Einstellungen (praktisch, wenn Sie sie neu installieren).${NL}   • apt purge Name: entfernt die Software UND ihre Einstellungen (sauber und vollständig).${NL}   • apt autoremove: entfernt Software, die nicht mehr gebraucht wird (installiert, um anderer Software zu dienen).${NL}${NL}⛔ GEFAHR: Vorsichtsregeln${NL}   • Lesen Sie immer die von apt vorgeschlagene Liste, bevor Sie mit J antworten. Enthält sie „linux-image“, „systemd“, „grub“ oder „libc“, antworten Sie N: Der Computer könnte nicht mehr starten.${NL}   • Im Zweifel nichts entfernen.${NL}${NL}🏋️ Ihre 12 größten absichtlich installierten Programme${NL}   Warum: Es sind die, die am meisten Platz belegen, nicht die, die Sie entfernen sollten. Zu jedem: wofür es dient und ob Sie es entfernen können.${NL}$TOP"
}
