T_COMP="Die Datenträger sind die Schränke Ihres Computers: Hier wird alles dauerhaft aufbewahrt."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="austauschbarer USB-Datenträger (ein USB-Stick besteht aus Flash-Speicher ohne bewegliche Teile; eine externe Festplatte hat eine rotierende Scheibe)";;
ssd) K="SSD (keine beweglichen Teile: schnell, leise, stoßfest)";;
*) K="mechanische Festplatte (eine Scheibe dreht sich: langsamer und verschleißt mit den Jahren)";;
esac
}
T_PART() { PT="$PT${NL}   • Partition $pn ($ps, $pf) eingebunden unter $pm: $u belegt"; }
T_DISK() { D="$D${NL}${NL}💽 Datenträger $N: „${n}“ — ${m:-unbekanntes Modell}${NL}   • Kapazität: $G GB${NL}   • Typ: $K$PT"; }
T_O() {
case $SL in
3) SU="Diese Kapazität reicht mehr als aus für Dokumente, Fotos und viele Filme. Nur aufwendige Spiele oder große Mengen an 4K-Videos könnten sie füllen, da diese Dateien sehr groß sind.";;
2) SU="Diese Kapazität reicht für den normalen Gebrauch, aber Fotos und Videos füllen sie schnell: Behalten Sie den freien Platz im Auge.";;
*) SU="Diese Kapazität ist begrenzt: Fotos und Videos füllen sie schnell, denken Sie an eine externe Festplatte.";;
esac
O="Ein Datenträger ist der Schrank, in dem Ihre Dokumente, Fotos, Programme und das System dauerhaft aufbewahrt werden. Im Gegensatz zum Arbeitsspeicher behält er alles, wenn man ausschaltet.${NL}Warum diese Seite: Wenn Sie die Schränke Ihres Computers, ihre Größe und ihren Typ kennen, wissen Sie, wo Sie etwas ablegen und was Sie sichern sollten.${NL}${NL}🔎 $N Datenträger auf diesem Computer erkannt:$D${NL}${NL}🏠 Hauptdatenträger (der des Systems): Kapazität $S, belegt zu $P ($U belegt, $A frei)${NL}   Warum: Ein zu voller Datenträger verlangsamt den Computer und verhindert Updates sowie das Speichern neuer Dateien. Unter 75 % ist alles in Ordnung."
R="Ausreichend Platz"; [ $NP -ge 75 ] && R="Platz im Auge behalten"; [ $NP -ge 90 ] && R="Hauptdatenträger fast voll: bald Platz schaffen"
}
