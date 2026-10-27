T_COMP="This page measures how long your computer takes to start, from pressing the button until the desktop is ready, and what takes the time."
T_COMP_NO="This page measures the time your computer takes to start, from pressing the button until the desktop is ready."
T_NO_O="The measurement is not available. Why: the systemd-analyze tool is missing, or startup is not finished."
T_NO_R="Measurement unavailable"
T_NO_CMD="systemd-analyze"
T_CMD="systemd-analyze, systemd-analyze blame (DMP uniquement)"
desc(){ case "$1" in
 NetworkManager-wait-online*) echo "waits for the network to be ready before continuing. Often the longest, harmless: it only blocks what needs the internet.";;
 plymouth*) echo "shows the startup screen (logo or animation).";;
 apt-daily*|apt*) echo "checks whether updates are available.";;
 udisks2*) echo "manages the disks and USB sticks that are plugged in.";;
 fwupd*) echo "manages hardware updates (BIOS, devices).";;
 ModemManager*) echo "manages 3G/4G modems, useless without a mobile stick.";;
 cups*) echo "prepares printing.";;
 bluetooth*) echo "prepares Bluetooth.";;
 accounts-daemon*) echo "manages the list of user accounts.";;
 gdm*|lightdm*|sddm*) echo "prepares the login screen.";;
 dev-*.device) echo "waits for a disk or partition to be ready.";;
 systemd-journal-flush*) echo "moves the event journal to the disk.";;
 systemd-udev-settle*) echo "waits for all hardware to be detected: slow by nature.";;
 e2scrub*|fstrim*) echo "disk maintenance.";;
 *) echo "system service started at boot.";; esac; }
T_BLITEM() { BLT="$BLT${NL}$i) $n: $t${NL}   • Role: $(desc "$n")${NL}"; }
T_O() {
DK=""
case $DKC in
ssd) DK="Your system disk is an SSD: it is one of the best assets for starting quickly.";;
hdd) DK="Your system disk is a mechanical hard drive: it is the leading cause of slow startup. An SSD would cut the time by 3 or 4.";;
esac
if [ $FWZ = 1 ]; then FW="not measurable (normal on some machines or in a virtual machine)"; else FW="${firmware} s"; fi
case $BIGC in fw) BIG="the firmware";; loader) BIG="the bootloader";; kernel) BIG="kernel loading";; *) BIG="service startup";; esac
O="Starting a computer takes 5 steps, like getting a restaurant ready before opening. Each one is measured here. Why this page: a startup that gets longer over time points to a cluttered system or an ageing disk.${NL}${NL}⏱️ Startup of $DB: ${total} s in total${NL}${NL}1) 🔌 Firmware (BIOS/UEFI): $FW${NL}   • Role: the very first program, stored on the motherboard. It checks that the hardware is present (memory, processor, disk).${NL}   • Why: this step does not depend on Debian, only on your machine.${NL}${NL}2) 🚪 Bootloader (GRUB): ${loader} s${NL}   • Role: it offers, if needed, a choice of system and then starts Debian.${NL}   • Why: a menu that waits a long time for an answer lengthens this step.${NL}${NL}3) 🫀 Kernel loading: ${KP} s (kernel ${kernel} s + initial preparation ${initrd} s)${NL}   • Role: the kernel is the core of Debian: it talks directly to the hardware. It loads into memory, detects the components, then a preparatory phase (initrd) activates the drivers needed to access the disk.${NL}   • Why: this step depends mainly on the speed of the disk and on the number of components to recognise.${NL}${NL}4) 🧩 Services and desktop: ${userspace} s${NL}   • Role: all the small background programs (network, sound, printing, login screen) start here, until the desktop appears.${NL}   • Why: this is the most variable step, because the more services you have, the longer it is.${NL}${NL}🐢 The 8 slowest services${NL}   Why: they show what is delaying step 4. A slow service is not necessarily a problem: several start at the same time.${NL}$BLT${NL}💽 $DK"
if [ "$TT" -lt 30 ]; then R="Fast startup"; X="Under 30 seconds is a good result: nothing to improve. The longest is $BIG."
elif [ "$TT" -lt 60 ]; then R="Decent startup"; X="Between 30 and 60 seconds is acceptable. The longest step is $BIG: that is where time could be saved. If one of the slow services above is of no use to you, it can be disabled."
else R="Slow startup"; X="Beyond a minute, something is delaying startup. The longest step is $BIG. Look at the 8 slowest services, and check the health of the disk (Disk page B4): a tired disk is a common cause."; fi
}
