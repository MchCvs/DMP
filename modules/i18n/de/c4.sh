# Deutsche Texte des Kollektors c4. Nur den Text übersetzen; ${...} und $NL unverändert lassen.
T_TITLE="Ermittelte Identität"
T_COMP="Die technischen Angaben sind der Personalausweis Ihres Computers: Modell, System, Version. Warum: Bei der Fehlersuche oder der Installation von Software beginnt man immer mit diesen Angaben."
T_X="Diese Angaben ändern sich fast nie: Sie sind vor allem nützlich, wenn man um Hilfe bittet, denn sie zeigen anderen genau Ihre Konfiguration. Notieren oder kopieren Sie sie."
T_AR64="64 Bit: der heutige Standard, kann mehr als 4 GB Speicher nutzen"
T_AR32="32 Bit: veraltet, auf 4 GB Speicher begrenzt"
T_O() {
O="🪪 Hier ist der Personalausweis Ihres Computers.${NL}${NL}🖥️ Gerät: ${MOD:-nicht lesbar} (Netzwerkname: $HOST)${NL}   Warum: damit lassen sich die genaue Dokumentation und die passenden Treiber finden.${NL}${NL}🐧 System: $PRETTY_NAME${NL}   Warum: bestimmt, welche Programme verfügbar sind und wie lange Sicherheitsupdates kommen.${NL}${NL}🫀 Kernel (das Herz des Systems): $KERNEL${NL}   Warum: Er spricht mit der Hardware; seine Version bestimmt die Kompatibilität mit neuen Komponenten.${NL}${NL}⚙️ Architektur: $AR${NL}   Warum: bestimmt, welche Programme installiert werden können.${NL}${NL}🔧 DMP-Werkzeuge: Python $PYV, Bash $BASHV${NL}   Warum: Mit diesen Werkzeugen liest und erklärt DMP Ihren Rechner.${NL}${NL}🌍 Systemsprache: ${LANG:-nicht gesetzt}${NL}   Warum: legt Sprache der Menüs, Datumsformat und Sonderzeichen fest.${NL}${NL}🖼️ Grafische Sitzung: ${DESK:-nicht erkannt} (${SESS:-?})${NL}   Warum: Das ist die Art der Desktop-Umgebung, die Aussehen und Verhalten der Fenster bestimmt."
}
