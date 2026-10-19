T_COMP="A package is a piece of software stored in Debian's library, ready to be installed or removed cleanly. This page takes stock of that library. Why: knowing what is installed and in good shape avoids conflicts."
T_CMD="dpkg-query, apt-mark, dpkg --audit (DMP uniquement)"
T_BIGFMT='%d) %s: %.0f MB\n   • Role: %s\n'
T_O() {
O="📦 Packages installed: $NI${NL}   Why: a package is a piece of software ready to install (like an app on a phone). Debian groups tens of thousands of them.${NL}${NL}💽 Space taken by all packages: $TOT GB${NL}   Why: this is the size of all installed programs, without your personal files.${NL}${NL}🙋 Installed on purpose: $MAN${NL}🔗 Installed automatically (dependencies): $((NI-MAN))${NL}   Why: some software needs other software to work. The latter install themselves, and can be removed when nothing needs them any more (see page C3).${NL}${NL}🧱 Packages deliberately held back: $HOLD${NL}   Why: a “held” package is excluded from updates. Zero is the normal situation.${NL}${NL}🔧 Broken or badly installed packages: $BRK${NL}   Why: a package interrupted during installation can get in the way of future updates. Zero is expected.${NL}${NL}🗑️ Configuration leftovers of removed software: $RC${NL}   Why: when software is removed, Debian keeps its settings in case you reinstall it. They take very little space.${NL}${NL}🏋️ The 10 heaviest packages${NL}   Why: know what takes the most space before you try to free some.${NL}$BIG"
case $HL in
brk) R="Packages to repair"; X="Some packages are badly installed. Type “sudo apt --fix-broken install”: it finishes interrupted installations. Do this before any update.";;
hold) R="Some packages are held back"; X="$HOLD package(s) will not be updated. If this is not intended, type “sudo apt-mark unhold package_name”.";;
*) R="Packages in good shape"; X="No broken or held package: the software system is healthy, updates will install without a hitch.";;
esac
}
