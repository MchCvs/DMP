T_COMP="Diese Seite zeigt, ob die Tür Ihres Computers zum Internet funktioniert: die Verbindung, was darüber läuft, ihre Qualität und ihre Geschwindigkeit."
T_COMP_NO="Diese Seite zeigt, ob Ihr Computer mit dem Internet verbunden ist und ob diese Verbindung gut funktioniert."
T_NO_O="Es wurde keine aktive Verbindung erkannt. Warum: Das Kabel ist abgezogen, das WLAN ist ausgeschaltet oder der Router ist aus. Ohne Verbindung ist weder Surfen noch das Durchführen von Updates möglich."
T_NO_R="Nicht verbunden"
T_NO_CMD="ip route"
T_CMD="ip, ping, /sys/class/net, getent (DMP uniquement)"
T_BYTE="B"
t1(){ if [ -z "$2" ] || [ "$2" = 100 ]; then echo "❌ keine Antwort"; else a=${3%.*}; if [ "$a" -lt 30 ]; then q="ausgezeichnet"; elif [ "$a" -lt 100 ]; then q="in Ordnung"; else q="langsam"; fi; echo "✅ antwortet in $3 ms ($q), $2 % Verluste"; fi; }
T_NM() {
case $N1 in en) NM="„en“ steht für Ethernet, also eine Verbindung per Kabel";; wl) NM="„wl“ steht für WLAN";; *) NM="vom System vergebener Name";; esac
case $N2 in onboard) NM="$NM; „o“ steht für auf der Hauptplatine integriert; die Ziffer ist seine Nummer";; pci) NM="$NM; der Rest gibt seinen Platz auf der Hauptplatine an";; esac
}
T_SPT() {
case $SQ in
3) SQT="ausgezeichnet: ausreichend für alle Anwendungen, selbst 4K-Video und große Downloads";;
2) SQT="ordentlich für Internet und Video, langsamer bei großen Dateien";;
*) SQT="sehr langsam: Prüfen Sie das Kabel, es ist möglicherweise beschädigt";;
esac
if [ $SQ -gt 0 ]; then SPT="$SP Mb/s ($SQT)"; else SPT="nicht messbar (normal bei WLAN)"; fi
}
T_QL() {
case $LV in 0) VD="✅ vernachlässigbar, nichts zu tun";; 1) VD="🟡 gering, aber im Auge zu behalten: Das kann von harmlosen ignorierten Nachrichten kommen oder von einer etwas anfälligen Verbindung";; *) VD="🔴 zu hoch: Echte Daten gehen verloren";; esac
if [ "$SK" = delta ]; then SUIV="Verlauf: $DD Paket(e) mehr verworfen seit der vorherigen Abfrage (vor $MN Min.). Bleibt diese Zahl bei 0 oder nahe 0, stammen die gezählten Pakete von früher und sind nicht beunruhigend; steigt sie schnell, während Sie surfen, gibt es ein echtes Problem."
else SUIV="Verlauf: Dies ist die erste Abfrage. Beim nächsten Mal zeigt DMP, ob diese Zahl steigt."; fi
QL="   • Hardwarefehler: $ER${NL}      Warum: Das sind Pakete, die beschädigt angekommen sind (defektes Kabel, defekte Buchse oder Netzwerkkarte). Null ist das erwartete Ergebnis.${NL}   • Verworfene (verlorene) Pakete: $DR von $TOT Paketen, also $PCT % des Datenverkehrs${NL}      Was ist das: Ein Paket ist ein kleines Datenpaket; „verworfen“ bedeutet, dass der Computer es weggeworfen hat, ohne es zu verarbeiten. Zwei mögliche Ursachen. Harmlos: Broadcast-Nachrichten des Netzwerks, die Sie nicht betreffen, oder ein Protokoll, das Sie nicht verwenden. Problem: Die Verbindung ist von schlechter Qualität oder überlastet, und nützliche Daten gehen verloren.${NL}      Warum beobachten: Ein verlorenes Paket muss erneut angefordert werden, was langsame Seiten, ruckelnde Videos und abgebrochene Anrufe verursacht. Unter 0,1 % ist es vernachlässigbar, von 0,1 bis 1 % sollte man es beobachten, darüber ist es ein Problem.${NL}      Urteil: $VD${NL}      $SUIV"
}
T_O() {
T_NM; T_SPT; T_QL
if [ $KW = 1 ]; then K="WLAN (kabellos)"; else K="Ethernetkabel"; fi
UT="$UD Tg. $UHR Std."
case $BL in
dl) BAL="Sie empfangen viel mehr, als Sie senden: Das ist normal, denn Surfen, ein Video ansehen oder Updates laden bedeutet vor allem Herunterladen.";;
up) BAL="Sie senden mehr, als Sie empfangen: Das ist ungewöhnlich. Es kann von einer Online-Sicherung oder vom Versand großer Dateien kommen.";;
*) BAL="Empfang und Versand liegen nah beieinander: ausgewogene Nutzung.";;
esac
O="🔗 Ihre Verbindung${NL}   • Technischer Name: $F (${NM})${NL}   • Typ: $K${NL}   • Adresse Ihres Computers: $IP${NL}      Warum: Das ist seine Hausnummer in Ihrem Netzwerk, die es anderen Geräten ermöglicht, ihn zu finden.${NL}   • Router (Gateway): $GW${NL}      Warum: Das ist die Ausgangstür ins Internet. Alles, was hinausgeht oder hereinkommt, läuft darüber.${NL}   • Verzeichnis der Webseiten (DNS): ${DNS:-unbekannt}${NL}      Warum: Es übersetzt einen Namen wie debian.org in eine Zahlenadresse, wie ein Telefonbuch.${NL}   • Verbindungsgeschwindigkeit: $SPT${NL}      Warum: Das ist die Breite der Leitung zwischen Ihrem Computer und dem Router (nicht Ihr Internetvertrag).${NL}${NL}📦 Was seit dem Einschalten übertragen wurde ($UT)${NL}   • ⬇️ Empfangen: $RH (etwa $PH Fotos zu je 1 MB), in $RP Paketen${NL}   • ⬆️ Gesendet: $TH, in $TP Paketen${NL}   • Durchschnittlich empfangen: etwa $MH pro Stunde${NL}      Warum: Ein Paket ist ein kleines Datenpaket; eine Seite oder ein Video kommt in Tausenden von Paketen an. $BAL${NL}${NL}🩺 Qualität der Verbindung${NL}${QL}${NL}${NL}🏓 Live-Tests${NL}   • Ihr Router: $(t1 x "$GL" "$GA")${NL}   • Internet: $(t1 x "$IL" "$IA")${NL}   • Verzeichnis (Webseitennamen): $([ $DN = 1 ] && echo '✅ funktioniert' || echo '❌ antwortet nicht')${NL}      Warum: Jedes Glied wird der Reihe nach getestet (Router, dann Internet, dann Verzeichnis), um genau zu erkennen, wo ein mögliches Problem liegt."
case $ST in
nobox) R="Der Router antwortet nicht"; X="Das Problem liegt zwischen Ihrem Computer und dem Router: Prüfen Sie das Kabel oder das WLAN und starten Sie dann den Router neu.";;
noinet) R="Lokales Netzwerk in Ordnung, aber kein Internet"; X="Der Router antwortet, also ist Ihr Computer in Ordnung: Das Problem liegt beim Router oder bei Ihrem Anbieter. Starten Sie den Router neu und kontaktieren Sie den Anbieter, falls es bestehen bleibt.";;
unstable) R="Instabile Verbindung"; X="Pakete gehen verloren: Das verursacht Unterbrechungen und Verlangsamungen. Prüfen Sie das Kabel oder gehen Sie näher an den Router.";;
nodns) R="Internet antwortet, aber Webseitennamen werden nicht aufgelöst"; X="Webseiten lassen sich nicht über ihren Namen öffnen: Der Verzeichnisdienst (DNS) ist ausgefallen, starten Sie den Router neu.";;
*) R="Gesunde Verbindung"; X="Jedes Glied antwortet gut: Surfen, Videos und Updates funktionieren normal.";;
esac
[ $LV -eq 1 ] && X="$X Hinweis: $DR verworfene(s) Paket(e), also $PCT % des Datenverkehrs. Warum beobachten: Verlorene Pakete müssen erneut angefordert werden, was Seiten verlangsamt und Videos ruckeln lässt. Details unter „Qualität der Verbindung“."
[ $LV -eq 2 ] && { R="Verbindung von schlechter Qualität"; X="$X $DR verworfene(s) Paket(e) ($PCT %) und $ER Fehler: Echte Daten gehen verloren. Prüfen Sie das Kabel (tauschen Sie es wenn möglich aus) oder gehen Sie im WLAN näher an den Router."; }
}
