T_COMP="Der Geschwindigkeitstest (Benchmark) ist wie das Stoppen eines Läufers: Der Computer muss jedes Mal dieselbe Anstrengung leisten, damit man weiß, wie schnell er ist, und seine Entwicklung verfolgen kann."
T_CMD="python3, dd (nur DMP)"
T_DKU="Typ nicht lesbar"
T_SSD="SSD"
T_HDD="mechanische Festplatte"
T_V0="✅ sehr gut"
T_V1="🟡 ordentlich"
T_V2="🔴 schwach"
T_O() {
O="⚡ Der Test misst jetzt sofort die Geschwindigkeit von drei Bauteilen. Er dauert einige Sekunden und schreibt vorübergehend 512 MB in Ihren persönlichen Ordner, die sofort wieder gelöscht werden.${NL}${NL}1) 🧮 Rechnen (Prozessor): $CT s für 5 Millionen Operationen${NL}   • Warum: So schnell „denkt“ der Computer. Je kürzer, desto besser.${NL}   • Richtwerte: unter 0,8 s sehr gut, 0,8 bis 1,6 s ordentlich, über 1,6 s schwach.${NL}   • Ihr Ergebnis: $(vd $LC)${NL}${NL}2) 🧠 Arbeitsspeicher: $MM MB/s${NL}   • Warum: So schnell bewegen sich die Daten auf dem Arbeitstisch. Das bestimmt, wie flüssig alle Programme laufen.${NL}   • Richtwerte: über 4000 MB/s sehr gut, 1500 bis 4000 ordentlich, unter 1500 schwach.${NL}   • Ihr Ergebnis: $(vd $LM)${NL}${NL}3) 💽 Datenträger (Schreiben, $DK): $DW MB/s${NL}   • Warum: So schnell werden Dateien, Aktualisierungen und der Systemstart gespeichert.${NL}   • Richtwerte: über 300 MB/s sehr gut (SSD), 100 bis 300 ordentlich, unter 100 schwach (mechanische Festplatte oder ausgelasteter Datenträger).${NL}   • Ihr Ergebnis: $(vd $LD)"
}
T_RX() {
case $W in
0) R="Schnelle Maschine"; X="Alle drei Messwerte sind gut: Prozessor, Arbeitsspeicher und Datenträger halten Schritt. Wiederholen Sie diesen Test von Zeit zu Zeit: Ein deutlicher Rückgang deutet auf ein Problem hin (müder Datenträger, Programm im Hintergrund).";;
1) R="Mittlere Geschwindigkeit: zu beobachten"; X="Mindestens ein Messwert ist nur ordentlich. Für den normalen Gebrauch nichts Ungewöhnliches. Wirkt die Maschine langsam, zeigt der schwächste Messwert das Bauteil, das man ansehen sollte.";;
*) R="Geringe Geschwindigkeit: zu verbessern"; X="Mindestens ein Messwert ist schwach: Dieses Bauteil bremst Ihren Computer. Der Datenträger lässt sich am leichtesten verbessern (eine SSD verändert alles). Starten Sie den Test erneut ohne ein anderes geöffnetes Programm, um zu prüfen, dass es nicht vorübergehend ist.";;
esac
}
