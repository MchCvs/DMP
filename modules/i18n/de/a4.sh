T_COMP="Das Netzwerk ist die Tür Ihres Computers zur übrigen Welt: Internet, Drucker, andere Geräte."
T_NO_O="Es wurde keine aktive Verbindung erkannt: Der Computer hat keinen Weg ins Internet. Warum: Möglicherweise ist das Kabel abgezogen oder das WLAN ausgeschaltet. Ohne Verbindung ist weder Surfen noch das Durchführen von Updates möglich."
T_NO_R="Nicht verbunden"
T_NO_CMD="ip route"
T_CMD="ip route, ip addr"
T_O() {
if [ -n "$WL" ]; then K="per WLAN (kabellos)"; XU="WLAN ist praktisch, aber seine Qualität hängt von der Entfernung zum Router und von Wänden ab: Wenn Seiten langsam laden, gehen Sie näher heran oder nutzen Sie ein Kabel."
else K="per Kabel"; XU="Ein Kabel ist in der Regel stabiler und schneller als WLAN, da das Signal keinen Störungen unterliegt."; fi
X="Diese Verbindung reicht zum Surfen, für Videos und für Updates. $XU"
O="Ihr Computer ist $K verbunden, über die Schnittstelle „${F}“. Seine Adresse im Netzwerk ist $A: Sie ist wie seine Hausnummer und ermöglicht es anderen Geräten, ihn zu finden. Warum das wichtig ist: Ohne diese Adresse könnte keine Webseite und kein Update zu Ihnen gelangen."
R="Verbunden"
}
