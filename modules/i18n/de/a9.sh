T_COMP="Die Stromversorgung liefert dem Computer Energie: der Strom aus der Steckdose oder der Akku, wenn Sie den Stecker ziehen."
T_COMP_NO="Die Stromversorgung liefert dem Computer Energie: der Strom aus der Steckdose, manchmal ein Akku."
T_NO_O="Kein Akku erkannt: Das ist ein Desktop-Computer, der dauerhaft am Stromnetz hängt. Warum: Ein Desktop-Computer hat keinen Akku, das ist völlig normal."
T_NO_R="Desktop-Computer, keine Batterie erkannt."
T_CMD="/sys/class/power_supply"
T_O() {
case $WL in
good) XU="Ihr Akku hat noch $W % seiner ursprünglichen Kapazität: Er ist in gutem Zustand.";;
mid) XU="Ihr Akku hat noch $W % seiner ursprünglichen Kapazität: Er ist etwas abgenutzt, die Laufzeit ist verringert.";;
bad) XU="Ihr Akku hat nur noch $W % seiner ursprünglichen Kapazität: Er ist stark abgenutzt, ein Austausch wird empfohlen.";;
*) XU="Der Verschleiß des Akkus konnte nicht gemessen werden.";;
esac
case "$S" in Charging) S="lädt";; Discharging) S="entlädt sich";; Full) S="voll";; "Not charging") S="lädt nicht";; esac
X="$XU Warum: Ein Akku verliert mit jedem Ladezyklus etwas Kapazität, das ist über die Jahre normal."
O="Ihr Akku ist zu $P % geladen (Zustand: $S). Warum das nützlich ist: Es zeigt Ihnen, wie lange Sie ohne Steckdose arbeiten können. Ein Akku, der nicht mehr lange durchhält, ist mit den Jahren abgenutzt."
R="Akku erkannt"
}
