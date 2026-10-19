T_COMP="Peripherals are everything you plug into the computer: keyboard, mouse, USB stick, webcam, printer. Each one goes through a USB port, the standard socket."
T_COMP_NO="Peripherals are everything you plug into the computer: keyboard, mouse, USB stick, webcam, printer."
T_NO_O="No USB device is detected for now. Why: nothing is plugged in, or your keyboard and mouse use another type of connection. This is not a problem."
T_NO_R="No USB device"
T_CMD="/sys/bus/usb/devices"
T_V() {
case $sp in 1.5) V="USB 1.0, very slow";; 12) V="USB 1.1, slow";; 480) V="USB 2.0, decent speed";; 5000) V="USB 3.0, fast";; 10000|20000) V="USB 3.x, very fast";; *) V="USB";; esac
}
T_T() {
case $c in
03) T="keyboard, mouse or gamepad"; E="This is what lets you control the computer. Without it, you could neither type nor click.";;
08) T="USB stick or external disk"; E="It is removable storage, useful for carrying or backing up files. A fast port speeds up copying.";;
0e) T="webcam"; E="It is the camera that films for video calls.";;
01) T="audio device (microphone, headset, speaker)"; E="It is used to hear or record sound.";;
07) T="printer"; E="It prints your documents.";;
e0) T="Bluetooth (wireless)"; E="It lets you connect a headset, mouse or gamepad without a cable.";;
09) T="hub (USB hub)"; E="It is a USB power strip: it multiplies the ports, but they share the same speed.";;
02|0a) T="modem or USB network card"; E="It is used to connect to a network.";;
ff) T="vendor-specific device"; E="Its precise role depends on the manufacturer, but the system recognised it.";;
*) T="USB device"; E="It is recognised by the system.";;
esac
}
T_DEV() { O="$O${NL}${NL}🔌 Device $N: “${nom}”${NL}   • Type: $T${NL}   • Role: $E${NL}   • Connection: $V"; }
T_O() {
X="This list is enough to check that everything you have plugged in is recognised, and therefore ready to use. If a device is missing, try another cable or another port, because the system can only use what it recognises. Tip: for a disk or a stick, prefer a port marked USB 3.0 (often blue), because copying is much faster there."
O="Your computer recognises $N USB device(s):$O"
R="$N device(s) recognised"
}
