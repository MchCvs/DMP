T_COMP="Diese Seite misst, wie lange Ihr Computer zum Starten braucht, vom Drücken des Knopfes bis zum bereiten Desktop, und was Zeit kostet."
T_COMP_NO="Diese Seite misst die Zeit, die Ihr Computer zum Starten braucht, vom Drücken des Knopfes bis zum bereiten Desktop."
T_NO_O="Die Messung ist nicht verfügbar. Warum: Das Werkzeug systemd-analyze fehlt, oder der Start ist noch nicht abgeschlossen."
T_NO_R="Messung nicht verfügbar"
T_NO_CMD="systemd-analyze"
T_CMD="systemd-analyze, systemd-analyze blame (DMP uniquement)"
desc(){ case "$1" in
 NetworkManager-wait-online*) echo "wartet, bis das Netzwerk bereit ist, bevor es weitergeht. Oft das Längste, harmlos: Es blockiert nur, was das Internet braucht.";;
 plymouth*) echo "zeigt den Startbildschirm an (Logo oder Animation).";;
 apt-daily*|apt*) echo "prüft, ob Updates verfügbar sind.";;
 udisks2*) echo "verwaltet die angeschlossenen Datenträger und USB-Sticks.";;
 fwupd*) echo "verwaltet Hardware-Updates (BIOS, Geräte).";;
 ModemManager*) echo "verwaltet 3G/4G-Modems, nutzlos ohne Mobilfunk-Stick.";;
 cups*) echo "bereitet das Drucken vor.";;
 bluetooth*) echo "bereitet Bluetooth vor.";;
 accounts-daemon*) echo "verwaltet die Liste der Benutzerkonten.";;
 gdm*|lightdm*|sddm*) echo "bereitet den Anmeldebildschirm vor.";;
 dev-*.device) echo "wartet, bis ein Datenträger oder eine Partition bereit ist.";;
 systemd-journal-flush*) echo "überträgt das Ereignisjournal auf den Datenträger.";;
 systemd-udev-settle*) echo "wartet, bis die gesamte Hardware erkannt ist: von Natur aus langsam.";;
 e2scrub*|fstrim*) echo "Wartung der Datenträger.";;
 *) echo "beim Start gestarteter Systemdienst.";; esac; }
T_BLITEM() { BLT="$BLT${NL}$i) $n: $t${NL}   • Aufgabe: $(desc "$n")${NL}"; }
T_O() {
DK=""
case $DKC in
ssd) DK="Ihr Systemdatenträger ist eine SSD: Das ist einer der größten Pluspunkte für einen schnellen Start.";;
hdd) DK="Ihr Systemdatenträger ist eine mechanische Festplatte: Das ist die häufigste Ursache für einen langsamen Start. Eine SSD würde die Zeit auf ein Drittel oder Viertel verkürzen.";;
esac
if [ $FWZ = 1 ]; then FW="nicht messbar (bei manchen Maschinen oder in einer virtuellen Maschine normal)"; else FW="${firmware} s"; fi
case $BIGC in fw) BIG="die Firmware";; loader) BIG="der Bootloader";; kernel) BIG="das Laden des Kernels";; *) BIG="der Start der Dienste";; esac
O="Das Starten eines Computers erfolgt in 5 Schritten, wie die Vorbereitung eines Restaurants vor der Öffnung. Jeder wird hier gemessen. Warum diese Seite: Ein Start, der mit der Zeit länger dauert, weist auf ein überladenes System oder einen alternden Datenträger hin.${NL}${NL}⏱️ Start vom $DB: insgesamt ${total} s${NL}${NL}1) 🔌 Firmware (BIOS/UEFI): $FW${NL}   • Aufgabe: das allererste Programm, auf der Hauptplatine gespeichert. Es prüft, ob die Hardware vorhanden ist (Arbeitsspeicher, Prozessor, Datenträger).${NL}   • Warum: Dieser Schritt hängt nicht von Debian ab, nur von Ihrer Maschine.${NL}${NL}2) 🚪 Bootloader (GRUB): ${loader} s${NL}   • Aufgabe: Er bietet bei Bedarf eine Auswahl des Systems an und startet dann Debian.${NL}   • Warum: Ein Menü, das lange auf eine Antwort wartet, verlängert diesen Schritt.${NL}${NL}3) 🫀 Laden des Kernels: ${KP} s (Kernel ${kernel} s + Vorbereitungsphase ${initrd} s)${NL}   • Aufgabe: Der Kernel ist der Kern von Debian: Er spricht direkt mit der Hardware. Er wird in den Arbeitsspeicher geladen und erkennt die Komponenten; dann aktiviert eine Vorbereitungsphase (initrd) die Treiber, die für den Zugriff auf den Datenträger nötig sind.${NL}   • Warum: Dieser Schritt hängt vor allem von der Geschwindigkeit des Datenträgers und der Zahl der zu erkennenden Komponenten ab.${NL}${NL}4) 🧩 Dienste und Desktop: ${userspace} s${NL}   • Aufgabe: Alle kleinen Hintergrundprogramme (Netzwerk, Ton, Drucken, Anmeldebildschirm) starten hier, bis der Desktop erscheint.${NL}   • Warum: Das ist der variabelste Schritt, denn je mehr Dienste Sie haben, desto länger dauert er.${NL}${NL}🐢 Die 8 langsamsten Dienste${NL}   Warum: Sie zeigen, was Schritt 4 verzögert. Ein langsamer Dienst ist nicht unbedingt ein Problem: Mehrere starten gleichzeitig.${NL}$BLT${NL}💽 $DK"
if [ "$TT" -lt 30 ]; then R="Schneller Start"; X="Unter 30 Sekunden ist ein gutes Ergebnis: nichts zu verbessern. Am längsten dauert $BIG."
elif [ "$TT" -lt 60 ]; then R="Ordentlicher Start"; X="Zwischen 30 und 60 Sekunden ist akzeptabel. Die längste Phase ist $BIG: Dort ließe sich Zeit gewinnen. Wenn einer der oben genannten langsamen Dienste Ihnen nichts nützt, kann er deaktiviert werden."
else R="Langsamer Start"; X="Über eine Minute verzögert etwas den Start. Die längste Phase ist $BIG. Sehen Sie sich die 8 langsamsten Dienste an und prüfen Sie den Zustand des Datenträgers (Seite Datenträger B4): Ein ermüdeter Datenträger ist eine häufige Ursache."; fi
}
