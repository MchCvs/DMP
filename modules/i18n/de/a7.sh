T_COMP="Debian ist das Betriebssystem: der große Dirigent, der die gesamte Hardware und alle Ihre Programme zusammenarbeiten lässt."
T_CMD="/etc/os-release, uname"
T_O() {
case $VC in
13) XU="Debian 13 ist die aktuelle stabile Version: Sie erhält Sicherheitsupdates, Sie sind auf dem neuesten Stand.";;
12) XU="Debian 12 ist die vorherige Version: Sie wird noch betreut (verlängerter Support), aber planen Sie den Wechsel auf Debian 13.";;
none) XU="Ihre Version hat keine Nummer (Testing oder Unstable): neuer, aber weniger stabil.";;
*) XU="Diese Debian-Version ist alt und erhält keine Sicherheitsupdates mehr: Ein Upgrade wird empfohlen, da neu entdeckte Sicherheitslücken nicht mehr behoben werden.";;
esac
X="$XU Für den normalen Gebrauch reicht Debian vollkommen aus: Browser, Büroarbeit und Multimedia laufen problemlos."
O="Sie verwenden $PRETTY_NAME. Der Kernel (der Kern des Systems, der direkt mit der Hardware spricht) hat die Version $(uname -r), für eine $(uname -m)-Architektur. Warum das wichtig ist: Wenn Sie die Version kennen, wissen Sie, ob sie noch betreut und aktualisiert wird. Debian ist für seine Stabilität bekannt."
R="Debian 13, aktuelle Version"; [ "$VC" = 12 ] && R="Debian 12, bald am Ende des Supports: Upgrade einplanen"; [ "$VC" = old ] && R="Alte Debian-Version, ohne Sicherheitsupdates"; [ "$VC" = none ] && R="Debian-Version nicht erkannt"
}
