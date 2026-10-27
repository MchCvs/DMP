T_COMP="A backup is the insurance for your files: it is useless until the day you need it, and on that day it saves everything."
T_CMD="command -v, /timeshift, /var/backups, lsblk"
T_NOTOOL="none"
T_NOSN="none found"
T_NOBK="none"
T_NOBR="none found"
T_O1() {
O="💾 A backup is a copy of your files kept somewhere else, safe. Why: a disk always ends up failing, and a handling mistake or a virus can erase everything. Without a copy, those files are lost forever.${NL}${NL}🧰 Backup tools installed: ${T:-$T_NOTOOL}${NL}   Why: you need a tool to copy regularly without thinking about it (timeshift: system copy; borg and restic: file copies; rsync: simple copy).${NL}${NL}📸 Latest system snapshot: ${SN:-$T_NOSN}${NL}   Why: it lets you go back to a previous state if an update goes wrong.${NL}${NL}🗃️ Automatic copy of Debian’s settings (/var/backups): $BKD${NL}   Why: Debian keeps the list of its software and accounts on its own. It does NOT contain your documents or your photos.${NL}${NL}🔌 External disks plugged in (USB stick, USB disk): $EXT${NL}   Why: a backup must be on a different medium from the computer; on the same disk, it disappears with it."
}
T_O2() {
O="$O${NL}${NL}🗄️ Latest Borg backup (Pika Backup) on a plugged-in medium: ${BRD:-$T_NOBR}${NL}   Why: Pika Backup stores its copies in a Borg repository. DMP finds this repository if it is on a plugged-in disk or stick and reads the date of the latest copy (the encrypted content stays unreadable)."
}
T_RX() {
case $ST in
old) R="Latest backup is old ($BRD): to watch"; X="The latest copy is $BAGE days old. The older it is, the more work you lose in case of failure. Run a Pika backup and schedule it (at least once a week).";;
recent) R="Recent backup found ($BRD)"; X="A Pika Backup copy is $BAGE day(s) old: your files are protected. Plug in the medium from time to time so DMP can check it.";;
none) R="No backup of your files: to watch"; X="DMP finds neither a tool nor a copy of your documents. Simple rule: three copies, on two different media, one of them elsewhere. To start: sudo apt install timeshift (system copies), then copy your documents to an external disk with rsync.";;
tool) R="Tool installed, no copy found: to watch"; X="A tool without a copy protects nothing. Run a first backup and schedule it.";;
*) R="System backup present"; X="A snapshot exists. Also check that your personal documents are copied to another medium.";;
esac
}
