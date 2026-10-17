#!/bin/bash

# ==================================================
# DMP - Graphiques historiques
# Version 1.5.0
# ==================================================


generate_chart_data()
{

HISTORY="$REPORT_DIR/history.csv"

CHART="$REPORT_DIR/chart_data.js"


tail -20 "$HISTORY" | \
awk -F";" '
BEGIN {
print "const labels=["
}
NR>1 {
printf "\"%s\",", $1
}
END {
print "];"
}
' > "$CHART"


echo "Données graphiques générées :"
echo "$CHART"

}

