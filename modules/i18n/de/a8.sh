T_COMP="Peripheriegeräte sind alles, was Sie an den Computer anschließen: Tastatur, Maus, USB-Stick, Webcam, Drucker. Jedes wird über einen USB-Anschluss verbunden, die Standardbuchse."
T_COMP_NO="Peripheriegeräte sind alles, was Sie an den Computer anschließen: Tastatur, Maus, USB-Stick, Webcam, Drucker."
T_NO_O="Im Moment wird kein USB-Gerät erkannt. Warum: Es ist nichts angeschlossen, oder Ihre Tastatur und Maus nutzen eine andere Verbindungsart. Das ist kein Problem."
T_NO_R="Kein USB-Gerät"
T_CMD="/sys/bus/usb/devices"
T_V() {
case $sp in 1.5) V="USB 1.0, sehr langsam";; 12) V="USB 1.1, langsam";; 480) V="USB 2.0, ordentliche Geschwindigkeit";; 5000) V="USB 3.0, schnell";; 10000|20000) V="USB 3.x, sehr schnell";; *) V="USB";; esac
}
T_T() {
case $c in
03) T="Tastatur, Maus oder Gamepad"; E="Damit steuern Sie den Computer. Ohne sie könnten Sie weder tippen noch klicken.";;
08) T="USB-Stick oder externe Festplatte"; E="Das ist ein austauschbarer Speicher, nützlich zum Transportieren oder Sichern von Dateien. Ein schneller Anschluss beschleunigt das Kopieren.";;
0e) T="Webcam"; E="Das ist die Kamera, die bei Videoanrufen filmt.";;
01) T="Audiogerät (Mikrofon, Headset, Lautsprecher)"; E="Es dient dazu, Ton zu hören oder aufzunehmen.";;
07) T="Drucker"; E="Er druckt Ihre Dokumente.";;
e0) T="Bluetooth (kabellos)"; E="Es ermöglicht, Headset, Maus oder Gamepad ohne Kabel zu verbinden.";;
09) T="Verteiler (USB-Hub)"; E="Das ist eine USB-Steckdosenleiste: Sie vervielfacht die Anschlüsse, aber diese teilen sich dieselbe Geschwindigkeit.";;
02|0a) T="Modem oder USB-Netzwerkkarte"; E="Sie dient dazu, sich mit einem Netzwerk zu verbinden.";;
ff) T="herstellerspezifisches Gerät"; E="Seine genaue Aufgabe hängt vom Hersteller ab, aber das System hat es erkannt.";;
*) T="USB-Gerät"; E="Es wird vom System erkannt.";;
esac
}
T_DEV() { O="$O${NL}${NL}🔌 Gerät $N: „${nom}“${NL}   • Typ: $T${NL}   • Aufgabe: $E${NL}   • Verbindung: $V"; }
T_O() {
X="Diese Liste genügt, um zu prüfen, dass alles, was Sie angeschlossen haben, erkannt wird und somit einsatzbereit ist. Fehlt ein Gerät, versuchen Sie ein anderes Kabel oder einen anderen Anschluss, denn das System kann nur nutzen, was es erkennt. Tipp: Für eine Festplatte oder einen Stick bevorzugen Sie einen als USB 3.0 gekennzeichneten Anschluss (oft blau), da das Kopieren dort viel schneller geht."
O="Ihr Computer erkennt $N USB-Gerät(e):$O"
R="$N Gerät(e) erkannt"
}
