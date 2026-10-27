# Deutsche Texte des Collectors e5. Nur den Text ändern.
T_COMP="Analyse = alle Einzelheiten unter dem Mikroskop betrachten. Nützlich, wenn Sie ein Problem diagnostizieren müssen."
T_R="Vollständige Diagnose verfügbar"
T_CMD="uptime -p + /proc/loadavg (nur DMP)"
T_NOTE="Wenn Load > Anzahl der Kerne: System überlastet. Sonst: alles in Ordnung"
T_O() {
O="System läuft seit: $UPTIME | Durchschnittliche Last (letzte Minute): $LOAD (0-4 bei 4 Kernen ist normal)"
}
