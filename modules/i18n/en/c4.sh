# English texts of the c4 collector. Translate only the text; keep ${...} and $NL as they are.
T_TITLE="Identity retrieved"
T_COMP="Technical information is your computer's identity card: model, system, version. Why: when troubleshooting or installing software, you always start with this information."
T_X="This information almost never changes: it mostly matters when asking for help, because it lets someone understand your exact setup. Note it down or copy it."
T_AR64="64-bit: the current standard, able to use more than 4 GB of memory"
T_AR32="32-bit: old, limited to 4 GB of memory"
T_O() {
O="🪪 Here is your computer's identity card.${NL}${NL}🖥️ Machine: ${MOD:-unreadable} (network name: $HOST)${NL}   Why: it lets you find the exact documentation and drivers.${NL}${NL}🐧 System: $PRETTY_NAME${NL}   Why: it determines which software is available and how long security updates last.${NL}${NL}🫀 Kernel (the heart of the system): $KERNEL${NL}   Why: it talks to the hardware; its version determines compatibility with recent components.${NL}${NL}⚙️ Architecture: $AR${NL}   Why: it determines which programs can be installed.${NL}${NL}🔧 DMP tools: Python $PYV, Bash $BASHV${NL}   Why: these are the tools DMP uses to read and explain your machine.${NL}${NL}🌍 System language: ${LANG:-not set}${NL}   Why: it sets the language of menus, the date format and special characters.${NL}${NL}🖼️ Graphical session: ${DESK:-not detected} (${SESS:-?})${NL}   Why: this is the desktop type, which determines how windows look and behave."
}
