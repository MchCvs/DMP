T_COMP="Die Hauptplatine ist die große zentrale Platine, an die alles angeschlossen wird: Prozessor, Arbeitsspeicher, Datenträger. Sie ist das Skelett des Computers: Wenn sie nicht funktioniert, funktioniert nichts."
T_COMP_NO="Die Hauptplatine ist die große zentrale Platine, an die alles angeschlossen wird: Prozessor, Arbeitsspeicher, Datenträger. Sie ist das Skelett des Computers."
T_NO_O="Seine Informationen können hier nicht gelesen werden. Warum: Das ist bei einer virtuellen Maschine oder einem Laptop, der sie verbirgt, häufig der Fall."
T_NO_R="Nicht verfügbar"
T_CMD="/sys/class/dmi/id"
T_O() {
if [ -n "$XA" ]; then XU="Das Startprogramm stammt aus dem Jahr $yr, also vor etwa $XA Jahr(en): Das gibt eine Vorstellung vom Alter der Hauptplatine. "; else XU=""; fi
X="${XU}Wenn der Computer startet und gut funktioniert, ist nichts zu tun: Ein BIOS-Update birgt ein Risiko, daher macht man es nur, um ein bestimmtes Problem zu beheben."
O="Ihre Hauptplatine ist eine „${N}“ des Herstellers $V. Sein Startprogramm (BIOS) hat die Version $B und ist vom $Y datiert. Warum das nützlich ist: Das BIOS ist das erste Programm, das startet, wenn Sie den Computer einschalten. Eine sehr alte Version kann Korrekturen vermissen lassen, wird aber nur geändert, wenn es nötig ist."
R="Identifiziert"
}
