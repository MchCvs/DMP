T_COMP="Diese Seite zeigt, wie voll jeder Speicherplatz Ihres Computers ist und wofür er dient."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="austauschbarer USB-Datenträger (ein USB-Stick besteht aus Flash-Speicher ohne bewegliche Teile; eine externe Festplatte enthält eine rotierende Scheibe, und DMP kann sie auf diesem Weg nicht unterscheiden)";;
ssd) K="SSD (keine beweglichen Teile: schnell, leise, stoßfest)";;
*) K="mechanische Festplatte (eine Scheibe dreht sich: langsamer und verschleißt mit den Jahren)";;
esac
}
T_DISK() { D="$D${NL}💽 Datenträger „${n}“: ${m:-unbekanntes Modell}${NL}   • Kapazität: $s${NL}   • Typ: $K${NL}"; }
T_NOHEALTH() { T="   ℹ️ Zustand nicht lesbar. Warum: Das Lesewerkzeug (smartmontools) hat keine Berechtigung, oder es ist ein USB-Stick oder ein virtueller Datenträger, die in der Regel keine lesbaren Gesundheitssensoren haben."; }
T_SAD() { SA="$SA${NL}🩺 Datenträger „${dk}“${NL}$T${NL}"; }
T_FS() {
case "$f" in
ext4|ext3) FS="ext4, das übliche Linux-Format: zuverlässig und schnell";;
vfat) FS="FAT32, ein einfaches Format, das alle Systeme verstehen (Windows, Linux, Kameras)";;
ntfs|fuseblk) FS="NTFS, das Windows-Format";;
exfat) FS="exFAT, ein Format für Sticks und externe Festplatten, das Windows, Mac und Linux verstehen";;
btrfs) FS="Btrfs, ein modernes Linux-Format mit Schnappschüssen";;
*) FS="$f";;
esac
}
T_RO() {
case "$tg" in
/) RO="Systempartition: Sie enthält Debian, alle installierten Programme und, wenn nichts anderes vorgesehen ist, Ihre Dateien. Warum das wichtig ist: Ist sie voll, kann der Computer nicht mehr richtig arbeiten.";;
/boot) RO="Boot-Partition: Sie enthält den Kernel, den Kern des Systems, der beim Einschalten gestartet wird. Warum das wichtig ist: Sie ist von Natur aus klein; ist sie voll, schlagen Kernel-Updates fehl.";;
/boot/efi) RO="Startpartition (UEFI): winzig, sie ermöglicht dem Computer, Debian beim Einschalten zu finden und zu starten. Warum das wichtig ist: Ohne sie startet der Computer nicht. Dass sie klein ist, ist normal: Lassen Sie die Finger davon.";;
/home) RO="Persönliche Partition: Ihre Dokumente, Fotos, Downloads und Einstellungen. Warum sie getrennt ist: So können Sie das System neu installieren oder wechseln, ohne Ihre Dateien zu verlieren.";;
/media/*|/run/media/*) RO="Wechselmedium (USB-Stick oder externe Festplatte), das gerade angeschlossen ist. Warum das wichtig ist: Entfernen Sie es immer ordnungsgemäß (Rechtsklick, „Auswerfen“), bevor Sie es abziehen, sonst können Dateien verloren gehen.";;
/mnt/*) RO="Datenträger, der manuell an dieser Stelle eingebunden wurde. Er dient dazu, zusätzliche Dateien zu speichern, wie ein zweiter Aufbewahrungsschrank.";;
*) RO="Partition, die hier für einen besonderen Zweck des Systems oder eines Programms eingebunden ist.";;
esac
}
T_PART() { P="$P${NL}🗂️ $tg  ($s)${NL}   • Belegung: $p ($u belegt, $a frei)${NL}   • Format: $FS${NL}   • Physischer Ort: $s${NL}   • Aufgabe: $RO${NL}"; }
T_O() {
O="Ein Datenträger ist das physische Objekt. Er ist in Teile unterteilt, die Partitionen heißen, wie ein Schrank, der in Schubladen aufgeteilt ist: Jede Partition hat ihre Aufgabe, und der Computer nutzt sie getrennt. Warum diese Aufteilung: Wenn man das System von Ihren Dateien trennt, wird alles sicherer und leichter zu reparieren.${NL}${NL}══ $ND physische(r) Datenträger ══$D${NL}══ Gesundheitszustand der Datenträger ══$SA${NL}══ Aktuell genutzte Partitionen ══$P"
case $WL in
2) R="Eine Partition ist fast voll: bald Platz schaffen"; X="Über 90 % wird der Computer langsamer und kann möglicherweise nicht mehr speichern. Schaffen Sie jetzt Platz.";;
1) R="Eine Partition füllt sich: im Auge behalten"; X="Ab 75 % sollten Sie große Dateien (Videos, Downloads) löschen oder verschieben.";;
*) R="Reichlich Platz"; X="Keine Partition ist fast voll, Sie können unbesorgt weitermachen.";;
esac
[ $HN -ge 2 ] && { R="Ein Datenträger zeigt Anzeichen eines Ausfalls: Sichern Sie jetzt Ihre Dateien"; X="$X Die im Gesundheitsabschnitt festgestellten Anzeichen deuten auf ein echtes Ausfallrisiko hin: Kopieren Sie Ihre wichtigen Dateien noch heute auf ein anderes Medium."; }
[ $HN -eq 1 ] && [ $WL -lt 2 ] && { R="Ein Datenträger sollte beobachtet werden"; X="$X Ein Gesundheitswert sollte beobachtet werden: Sichern Sie vorsichtshalber Ihre wichtigen Dateien."; }
}
