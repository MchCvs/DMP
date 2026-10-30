T_COMP="The motherboard is the large central board where everything plugs in: processor, memory, disk. It is the skeleton of the computer: if it does not work, nothing works."
T_COMP_NO="The motherboard is the large central board where everything plugs in: processor, memory, disk. It is the skeleton of the computer."
T_NO_O="Its information cannot be read here. Why: this is common on a virtual machine or a laptop that hides it."
T_NO_R="Not available"
T_CMD="/sys/class/dmi/id"
T_O() {
if [ -n "$XA" ]; then [ "$XA" -le 1 ] && S="" || S="s"; XU="The startup program dates from $yr, about $XA year$S ago: this gives an idea of the motherboard's age. "; else XU=""; fi
X="${XU}If the computer starts and works well, there is nothing to do: updating the BIOS carries a risk, so it is only done to fix a specific problem."
O="Your motherboard is a “${N}” from the manufacturer $V. Its startup program (BIOS) is version $B, dated $Y. Why it is useful: the BIOS is the first program that runs when you switch the computer on. A very old version may lack fixes, but it is only changed when necessary."
R="Identified"
}
