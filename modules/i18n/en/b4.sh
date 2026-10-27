T_COMP="This page shows how full each storage space on your computer is, and what it is for."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="removable USB device (a USB stick uses flash memory with no moving parts; an external hard drive contains a spinning platter, and DMP cannot tell them apart this way)";;
ssd) K="SSD (no moving parts: fast, silent, shock-resistant)";;
*) K="mechanical hard drive (a platter spins: slower, and it wears out over the years)";;
esac
}
T_DISK() { D="$D${NL}💽 Disk “${n}”: ${m:-unknown model}${NL}   • Capacity: $s${NL}   • Type: $K${NL}"; }
T_NOHEALTH() { T="   ℹ️ Status not readable. Why: the reading tool (smartmontools) is not authorised, or this is a USB stick or a virtual disk, which generally have no readable health sensors."; }
T_SAD() { SA="$SA${NL}🩺 Disk “${dk}”${NL}$T${NL}"; }
T_FS() {
case "$f" in
ext4|ext3) FS="ext4, the usual Linux format: reliable and fast";;
vfat) FS="FAT32, a simple format understood by all systems (Windows, Linux, cameras)";;
ntfs|fuseblk) FS="NTFS, the Windows format";;
exfat) FS="exFAT, a format for sticks and external disks, understood by Windows, Mac and Linux";;
btrfs) FS="Btrfs, a modern Linux format with snapshots";;
*) FS="$f";;
esac
}
T_RO() {
case "$tg" in
/) RO="System partition: it contains Debian, all installed programs and, if nothing else is planned, your files. Why it matters: if it is full, the computer can no longer work properly.";;
/boot) RO="Boot partition: it contains the kernel, the core of the system started at power-on. Why it matters: small by nature, if it is full kernel updates fail.";;
/boot/efi) RO="Startup partition (UEFI): tiny, it lets the computer find and start Debian when you switch it on. Why it matters: without it, the computer does not start. It is normal for it to be small: do not touch it.";;
/home) RO="Personal partition: your documents, photos, downloads and settings. Why it is separate: you can reinstall or change system without losing your files.";;
/media/*|/run/media/*) RO="Removable media (USB stick or external disk) currently plugged in. Why it matters: always remove it properly (right click, “Eject”) before unplugging, otherwise files may be lost.";;
/mnt/*) RO="Disk added manually at this location. It is used to store extra files, like a second storage cabinet.";;
*) RO="Partition mounted here for a particular use of the system or of a program.";;
esac
}
T_PART() { P="$P${NL}🗂️ $tg  ($s)${NL}   • Usage: $p ($u used, $a free)${NL}   • Format: $FS${NL}   • Physical location: $s${NL}   • Role: $RO${NL}"; }
T_O() {
O="A disk is the physical object. It is divided into parts called partitions, like a cabinet split into drawers: each partition has its role, and the computer uses them separately. Why this split: separating the system from your files makes everything safer and easier to repair.${NL}${NL}══ $ND physical disk(s) ══$D${NL}══ Disk health status ══$SA${NL}══ Partitions in use right now ══$P"
case $WL in
2) R="A partition is almost full: free up space quickly"; X="Above 90 %, the computer slows down and may no longer be able to save. Free up space now.";;
1) R="A partition is filling up: keep an eye on it"; X="Beyond 75 %, consider deleting or moving large files (videos, downloads).";;
*) R="Plenty of space"; X="No partition is close to being full, you can carry on without worry.";;
esac
[ $HN -ge 2 ] && { R="A disk shows signs of failure: back up your files now"; X="$X The signs found in the health section indicate a real risk of failure: copy your important files to another medium today."; }
[ $HN -eq 1 ] && [ $WL -lt 2 ] && { R="A disk needs watching"; X="$X A health indicator needs watching: back up your important files as a precaution."; }
}
