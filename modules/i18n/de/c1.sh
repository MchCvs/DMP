T_COMP="Updates sind Impfungen für Ihren Computer: Jedes Mal, wenn in einer Software eine Lücke oder ein Fehler entdeckt wird, veröffentlichen ihre Autoren eine korrigierte Version. Warum man sie installiert: Eine nicht aktualisierte Software behält ihre Lücken, und genau die nutzen Hacker und Viren aus."
T_CMD="apt list --upgradable (DMP uniquement)"
T_SECL="🔴 Sicherheit"; T_ORDL="🔵 gewöhnlich"
T_LFMT='   • %s: %s → %s (%s)\n'
T_O() {
if [ $UP -eq 0 ]; then O="✅ Kein Update ausstehend: Alle Ihre Programme sind auf dem neuesten bekannten Stand.${NL}   Warum: Keine bereits behobene Lücke bleibt offen."
else O="📦 $UP Update(s) ausstehend, davon $SU Sicherheitsupdates.${NL}${NL}Liste (die wichtigsten zuerst, höchstens 15):${NL}$LST${NL}${NL}🔴 Sicherheit: behebt eine bekannte Lücke, die ein Hacker ausnutzen kann, solange sie nicht installiert ist.${NL}🔵 Gewöhnlich: behebt einen Fehler oder bringt eine Verbesserung, weniger dringend.${NL}   Eine Zeile lesen: Name des Programms: aktuelle Version → verfügbare Version."; fi
[ $AG -ge 0 ] && O="$O${NL}${NL}🕒 Letzte Prüfung auf Neuigkeiten: vor $AG Tag(en).${NL}   Warum: Diese Liste ist nur zuverlässig, wenn sie aktuell ist. Nach mehr als 7 Tagen führen Sie zuerst „sudo apt update“ aus."
O="$O${NL}${NL}🛠️ So installieren Sie (in ein Terminal einzugeben)${NL}   1) sudo apt update: aktualisiert die Liste der Neuigkeiten (installiert nichts).${NL}   2) sudo apt upgrade: installiert die Updates. Debian entfernt nichts, ohne es Ihnen zu sagen.${NL}   Warum in zwei Schritten: Man sieht zuerst, was es gibt, und entscheidet dann zu installieren."
if [ $SU -gt 0 ]; then R="Bald zu erledigen"; X="$SU Sicherheitsupdate(s) warten: Solange sie nicht installiert sind, bleiben bekannte Lücken offen. Wie bei einer Impfung gilt: Je früher, desto besser sind Sie geschützt. Führen Sie die beiden Befehle oben aus."
elif [ $UP -gt 0 ]; then R="Zu erledigen, nicht dringend"; X="Keine Sicherheitslücke ausstehend, nur Verbesserungen. Installieren Sie sie diese Woche: Das hält das System konsistent und verhindert Anhäufung."
else R="System ist aktuell"; X="Nichts zu tun. Behalten Sie die Gewohnheit bei, jede Woche zu prüfen, denn regelmäßig werden neue Lücken behoben."; fi
}
