T_COMP="Die Datensicherung ist die Versicherung für Ihre Dateien: Sie nützt nichts bis zu dem Tag, an dem man sie braucht, und an diesem Tag rettet sie alles."
T_CMD="command -v, /timeshift, /var/backups, lsblk"
T_NOTOOL="keine"
T_NOSN="keine gefunden"
T_NOBK="keine"
T_NOBR="keine gefunden"
T_O1() {
O="💾 Eine Datensicherung ist eine Kopie Ihrer Dateien, die woanders sicher aufbewahrt wird. Warum: Ein Datenträger fällt irgendwann immer aus, und ein Bedienfehler oder ein Virus kann alles löschen. Ohne Kopie sind diese Dateien für immer verloren.${NL}${NL}🧰 Installierte Sicherungswerkzeuge: ${T:-$T_NOTOOL}${NL}   Warum: Sie brauchen ein Werkzeug, das regelmäßig kopiert, ohne dass Sie daran denken müssen (timeshift: Kopie des Systems; borg und restic: Kopien von Dateien; rsync: einfache Kopie).${NL}${NL}📸 Letzter Systemschnappschuss: ${SN:-$T_NOSN}${NL}   Warum: Er erlaubt es, zu einem früheren Zustand zurückzukehren, wenn eine Aktualisierung schiefgeht.${NL}${NL}🗃️ Automatische Kopie der Debian-Einstellungen (/var/backups): $BKD${NL}   Warum: Debian bewahrt die Liste seiner Programme und Konten selbst auf. Sie enthält NICHT Ihre Dokumente oder Fotos.${NL}${NL}🔌 Angeschlossene externe Datenträger (USB-Stick, USB-Festplatte): $EXT${NL}   Warum: Eine Sicherung muss auf einem anderen Medium als dem Computer liegen; auf demselben Datenträger verschwindet sie mit ihm."
}
T_O2() {
O="$O${NL}${NL}🗄️ Letzte Borg-Sicherung (Pika Backup) auf einem angeschlossenen Medium: ${BRD:-$T_NOBR}${NL}   Warum: Pika Backup legt seine Kopien in einem Borg-Depot ab. DMP findet dieses Depot, wenn es auf einem angeschlossenen Datenträger oder Stick liegt, und liest das Datum der letzten Kopie (der verschlüsselte Inhalt bleibt unlesbar)."
}
T_RX() {
case $ST in
old) R="Letzte Sicherung ist alt ($BRD): zu beobachten"; X="Die letzte Kopie ist $BAGE Tage alt. Je älter sie ist, desto mehr Arbeit verlieren Sie bei einem Ausfall. Starten Sie eine Pika-Sicherung und planen Sie sie ein (mindestens einmal pro Woche).";;
recent) R="Aktuelle Sicherung gefunden ($BRD)"; X="Eine Pika-Backup-Kopie ist $BAGE Tag(e) alt: Ihre Dateien sind geschützt. Schließen Sie das Medium von Zeit zu Zeit an, damit DMP sie prüfen kann.";;
none) R="Keine Sicherung Ihrer Dateien: zu beobachten"; X="DMP findet weder ein Werkzeug noch eine Kopie Ihrer Dokumente. Einfache Regel: drei Kopien auf zwei verschiedenen Medien, davon eine an einem anderen Ort. Zum Einstieg: sudo apt install timeshift (Systemkopien), dann Ihre Dokumente mit rsync auf eine externe Festplatte kopieren.";;
tool) R="Werkzeug installiert, keine Kopie gefunden: zu beobachten"; X="Ein Werkzeug ohne Kopie schützt nichts. Starten Sie eine erste Sicherung und planen Sie sie ein.";;
*) R="Systemsicherung vorhanden"; X="Ein Schnappschuss existiert. Prüfen Sie auch, ob Ihre persönlichen Dokumente auf ein anderes Medium kopiert sind.";;
esac
}
