#!/bin/bash
CPU_USAGE=$(ps aux | awk '{sum+=$3} END {print int(sum)}')
MEM_USAGE=$(free | grep "^Mem:" | awk '{print int(($3/$2)*100)}')
DISK_USAGE=$(df / | tail -1 | awk '{print int(($3/$2)*100)}')
SCORE=$((100 - (CPU_USAGE + MEM_USAGE + DISK_USAGE) / 3))
SCORE=$([[ $SCORE -lt 0 ]] && echo 0 || echo $SCORE)
echo "{\"comprendre\":\"Score = une note de santé globale (0-100). Comme un bulletin du médecin pour votre ordinateur.\",\"observations\":\"CPU: $CPU_USAGE% | RAM: $MEM_USAGE% | Disque: $DISK_USAGE% | Score final: $SCORE/100\",\"resultat\":\"$([[ $SCORE -gt 80 ]] && echo 'Excellent' || [[ $SCORE -gt 60 ]] && echo 'Bon' || echo 'À améliorer')\",\"informations_techniques\":{\"cmd\":\"ps aux + free + df (DMP uniquement)\",\"cpu\":$CPU_USAGE,\"mem\":$MEM_USAGE,\"disk\":$DISK_USAGE,\"score\":$SCORE,\"note\":\"Score >80 = Excellent | 60-80 = Bon | <60 = Nettoyage recommandé\"}}"
