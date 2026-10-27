T_COMP="Disks are your computer's cabinets: this is where everything is stored permanently."
T_CMD="lsblk, df -h"
T_K() {
case $KT in
usb) K="removable USB device (a USB stick uses flash memory with no moving parts; an external hard drive has a spinning platter)";;
ssd) K="SSD (no moving parts: fast, silent, shock-resistant)";;
*) K="mechanical hard drive (a platter spins: slower, and it wears out over the years)";;
esac
}
T_PART() { PT="$PT${NL}   • Partition $pn ($ps, $pf) mounted on $pm: $u used"; }
T_DISK() { D="$D${NL}${NL}💽 Disk $N: “${n}” — ${m:-unknown model}${NL}   • Capacity: $G GB${NL}   • Type: $K$PT"; }
T_O() {
case $SL in
3) SU="This capacity is more than enough for documents, photos and plenty of films. Only heavy games or large amounts of 4K video could fill it, because those files are very large.";;
2) SU="This capacity is enough for everyday use, but photos and videos fill it quickly: keep an eye on the remaining space.";;
*) SU="This capacity is limited: photos and videos will fill it quickly, consider an external disk.";;
esac
O="A disk is the cabinet where your documents, photos, programs and the system are stored for good. Unlike memory, it keeps everything when you switch off.${NL}Why this page: knowing your computer's cabinets, their size and type, means knowing where to store things and what to back up.${NL}${NL}🔎 $N disk(s) detected on this computer:$D${NL}${NL}🏠 Main disk (the one holding the system): capacity $S, used at $P ($U used, $A free)${NL}   Why: a disk that is too full slows the computer down and prevents updates and saving new files. Below 75 %, you are fine."
R="Enough space"; [ $NP -ge 75 ] && R="Space to keep an eye on"; [ $NP -ge 90 ] && R="Main disk almost full: free up space quickly"
}
