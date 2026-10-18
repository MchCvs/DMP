T_COMP="Das ist das Gehirn Ihres Computers. Es denkt und führt die Berechnungen aus. Je schneller es ist, desto schneller laufen Ihre Programme."
T_CMD="nproc, lscpu, /proc/loadavg (DMP uniquement)"
T_O() {
case $LV in
3) Q="eine hohe Zahl: Ihr Computer kann viele Dinge gleichzeitig erledigen (Video, Surfen, Spiele), ohne langsamer zu werden";;
2) Q="eine angenehme Zahl für den normalen Gebrauch: Internet, Büroarbeit, Videos";;
*) Q="eine bescheidene Zahl: Der Computer kann langsamer werden, wenn man viele Dinge gleichzeitig startet";;
esac
O="Ihr Prozessor ist ein „${M}“. Er hat $C Kerne. Ein Kern ist wie ein Arbeiter: Je mehr es gibt, desto besser verteilt sich die Arbeit und desto schneller geht sie. Bei $C Kernen ist das $Q. Aktuelle Systemlast: $L. Dieser Wert misst, wie viele Aufgaben darauf warten, an die Reihe zu kommen: Bleibt er unter $C, arbeitet der Prozessor ohne Überlastung, da jeder Kern seine eigene Aufgabe hat. Über $C bilden die Aufgaben eine Warteschlange und der Computer wird langsamer."
case $GM in
3) GN="Einstiegsklasse"; GX="Ein i3 reicht für Internet, Büroarbeit und Videos, kann aber Mühe haben, wenn man viele Dinge gleichzeitig macht";;
5) GN="Mittelklasse"; GX="Ein i5 ist die häufigste Wahl, weil er das beste Gleichgewicht zwischen Geschwindigkeit und Preis bietet: Er reicht mehr als aus für Internet, Büroarbeit, Videos, Fotos und gängige Spiele";;
7) GN="Oberklasse"; GX="Ein i7 ist schnell und bewältigt Videoschnitt, kreative Arbeit und anspruchsvolle Spiele mühelos";;
9) GN="Spitzenklasse"; GX="Ein i9 ist ein sehr leistungsstarker Prozessor, gedacht für sehr anspruchsvolle Anwendungen";;
esac
case $FA in
intel) E="Was ist ein Core i5, i7 ...? Intel ist einer der beiden großen Prozessorhersteller (der andere ist AMD). „Core“ ist die Reihe für den Massenmarkt, nach Leistungsstufen geordnet, wie die Größen derselben Marke: i3 (Einstiegsklasse), i5 (Mittelklasse), i7 (Oberklasse), i9 (Spitzenklasse). Ihrer gehört zur ${GN}: ${GX}. Die Zahl nach dem Buchstaben i (zum Beispiel 12400) gibt die Generation und die Leistung an: Je größer sie ist, desto neuer und effizienter ist der Prozessor. Warum es nützlich ist, das zu wissen: Es zeigt Ihnen, was Ihr Computer bequem leisten kann und wann es vielleicht Zeit ist, ihn zu ersetzen.";;
amd) E="Was ist ein Ryzen? AMD ist einer der beiden großen Prozessorhersteller (der andere ist Intel). Ryzen ist die Reihe für den Massenmarkt, nach Leistungsstufen geordnet: Ryzen 3 (Einstiegsklasse), 5 (Mittelklasse, am weitesten verbreitet), 7 (Oberklasse), 9 (Spitzenklasse). Die folgende Zahl gibt die Generation an: Je größer sie ist, desto neuer ist der Prozessor. Warum es nützlich ist, das zu wissen: Es zeigt Ihnen, was Ihr Computer bequem leisten kann.";;
*) E="Der Name Ihres Prozessors verrät seinen Hersteller und seine Leistungsstufe. Vergleichen Sie ihn mit anderen Modellen desselben Herstellers, um zu erfahren, ob er neu und leistungsstark ist.";;
esac
O="$O $E"
case $LV in
3) U="Für den normalen Gebrauch (Internet, Büroarbeit, Videos, Fotos) reicht er mehr als aus. Er eignet sich auch für anspruchsvolle Anwendungen wie Videoschnitt oder Spiele, da sich die Arbeit bei $C Kernen gut verteilt.";;
2) U="Für den normalen Gebrauch (Internet, Büroarbeit, Videos, Fotos) reicht er aus. Für Videoschnitt oder sehr neue Spiele wird es knapp, da diese Aufgaben viele Kerne gleichzeitig benötigen.";;
*) U="Er reicht für Internet und leichte Büroarbeit, ist aber eingeschränkt, sobald man mehrere Dinge gleichzeitig macht, da sich nur $C Kerne die Arbeit teilen.";;
esac
if [ -n "$Y" ]; then
 case $AC in new) D="neu";; mid) D="von mittlerem Alter";; *) D="alt";; esac
 AG="Alter: Der Prozessor ist $D, erschienen um $Y. Warum das wichtig ist: Ein neuer Prozessor ist schneller und verbraucht weniger Energie; ein alter bleibt nutzbar, solange Ihre Anwendungen einfach sind, wird aber mit immer anspruchsvollerer Software irgendwann langsam."
else AG="Sein Alter konnte nicht automatisch bestimmt werden: Je größer die Zahl in seinem Namen, desto neuer ist er."; fi
if [ -n "$OV" ]; then R="Im Moment überlastet: zu viele Aufgaben warten"; else R="Funktioniert gut"; fi
R="$R. $U $AG"
}
