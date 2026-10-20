# English texts of collector e5. Edit the text only.
T_COMP="Analysis = looking at every detail under a microscope. Useful if you have a problem to diagnose."
T_R="Full diagnostic available"
T_CMD="uptime -p + /proc/loadavg (DMP only)"
T_NOTE="If Load > number of cores: system overloaded. Otherwise: all good"
T_O() {
O="System running for: $UPTIME | Average load (last minute): $LOAD (0-4 on 4 cores is normal)"
}
