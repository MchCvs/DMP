#!/bin/bash
UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
LOAD=$(cat /proc/loadavg | awk '{print $1}')
echo "{\"comprendre\":\"Analyse = regarder tous les détails en microscope. Utile si vous avez un problème à diagnostiquer.\",\"observations\":\"Système actif depuis: $UPTIME | Charge moyenne (dernière minute): $LOAD (0-4 sur 4 cœurs c'est normal)\",\"resultat\":\"Diagnostic complet disponible\",\"informations_techniques\":{\"cmd\":\"uptime -p + /proc/loadavg (DMP uniquement)\",\"uptime\":\"$UPTIME\",\"load_avg\":$LOAD,\"note\":\"Si Load > nombre de cœurs: système surchargé. Sinon: c'est bon\"}}"
