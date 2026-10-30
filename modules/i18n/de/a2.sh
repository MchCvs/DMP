T_COMP="Der Arbeitsspeicher (RAM) ist der Schreibtisch Ihres Computers: Alles, was Sie öffnen, wird dort abgelegt, um sehr schnell benutzt zu werden. Wenn Sie ausschalten, wird der Schreibtisch leergeräumt."
T_CMD="/proc/meminfo"
T_O() {
case $LV in
3) Q="eine sehr große Menge: Sie können ohne Sorge viele Dinge gleichzeitig öffnen"
XU="Er reicht mehr als aus, selbst für Videoschnitt oder mehrere aufwendige Programme gleichzeitig, da diese Aufgaben viele Daten auf dem Schreibtisch halten.";;
2) Q="eine angenehme Menge für Internet, Büroarbeit, Videos und ein wenig kreative Arbeit"
XU="Er reicht für den normalen Gebrauch (Internet mit vielen Tabs, Büroarbeit, Videos, Fotos). Für aufwendigen Videoschnitt wäre er knapp, da diese Aufgaben den Schreibtisch schnell füllen.";;
1) Q="eine ordentliche Menge, die aber knapp wird, wenn Sie viele Dinge öffnen"
XU="Er reicht für Internet und Büroarbeit, wird aber bei vielen Tabs knapp, da aktuelle Browser anspruchsvoll sind.";;
*) Q="eine geringe Menge: Der Computer kann schnell langsam werden"
XU="Er ist klein: Er reicht für einen leichten Gebrauch und läuft besser, wenn wenige Programme geöffnet sind.";;
esac
case $PL in
0) XE="Im Moment nutzen Sie nur einen Teil davon ($P %): Sie haben Spielraum.";;
1) XE="Er ist ziemlich stark ausgelastet ($P %): Er wird langsam voll, schließen Sie Programme, die Sie nicht mehr brauchen.";;
*) XE="Er ist fast voll ($P %): Schließen Sie einige Programme oder Tabs.";;
esac
R="Arbeitsspeicher in guter Verfassung"; [ "$PL" = 1 ] && R="Arbeitsspeicher ziemlich stark ausgelastet, im Auge behalten"; [ "$PL" = 2 ] && R="Arbeitsspeicher fast voll: Der Computer wird möglicherweise langsamer"
X="$XU $XE"
O="Ihr Computer hat $T GB Arbeitsspeicher, $Q. Im Moment sind $P % belegt und $D GB sind noch frei. Warum das wichtig ist: Wenn der Schreibtisch voll ist, muss der Computer Dinge auf der Festplatte ablegen, die viel langsamer ist, und alles wird langsamer. Solange noch freier Platz vorhanden ist, läuft alles flüssig."
}
