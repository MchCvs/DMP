T_COMP="Die Grafikkarte ist der Maler Ihres Computers: Sie zeichnet alles, was auf dem Bildschirm erscheint (Fenster, Videos, Spiele)."
T_COMP_NO="Die Grafikkarte erzeugt das Bild, das Sie auf dem Bildschirm sehen."
T_NO_O="Es konnte keine Grafikkarte erkannt werden. Warum: Das Erkennungswerkzeug fehlt möglicherweise, oder der Computer ist eine virtuelle Maschine."
T_NO_R="Nicht erkannt"
T_CMD="lspci"
T_O() {
case $GK in
ded) K="Das ist eine dedizierte Karte: ein separates, leistungsstarkes Bauteil, gedacht für Spiele und Videoschnitt."
XU="Sie reicht für Spiele und Videoschnitt, da es ein eigenes Bauteil mit eigener Leistung ist.";;
*) K="Das ist ein integrierter Grafikchip: Er sitzt im Prozessor, reicht für Internet, Video und Büroarbeit, ist aber für aktuelle Spiele weniger geeignet."
XU="Er reicht für Internet, Videos (auch in HD), Fotos und Büroarbeit. Für aktuelle 3D-Spiele oder aufwendigen Videoschnitt ist er begrenzt, da er sich die Leistung mit dem Prozessor teilt.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="neu";; mid) D="von mittlerem Alter";; *) D="alt";; esac
 AG="Alter: Dem Namen nach ist der Chip $D, erschienen um $Y (vor etwa $A Jahr(en)). Warum das wichtig ist: Ein neuer Chip ist schneller, verbraucht weniger Energie und kann die neuesten Videos abspielen, ohne den Prozessor zu belasten; ein alter reicht weiterhin für Internet und Büroarbeit, hat aber mit modernen Videos und aktuellen Spielen Mühe."
else AG=""; fi
X="$XU $AG"
O="Ihr Computer verwendet: „${G}“. $K Warum es nützlich ist, das zu wissen: Es zeigt Ihnen, ob der Computer Spiele oder Videoschnitt bewältigen kann oder eher für den normalen Gebrauch gedacht ist."
R="Erkannt"
}
