#!/bin/bash
CORES=$(nproc)
RAM=$(free -h | grep "^Mem:" | awk '{print $2}')
DISK=$(df -h / | tail -1 | awk '{print $2}')
HOSTNAME=$(hostname)
echo "{\"comprendre\":\"Résumé = regarder le tableau de bord de votre voiture. En un coup d'œil, vous voyez l'essentiel.\",\"observations\":\"Hostname: $HOSTNAME | CPU: $CORES cœurs | RAM: $RAM | Disque: $DISK\",\"resultat\":\"Système complet\",\"informations_techniques\":{\"cmd\":\"nproc + free -h + df -h + hostname\",\"cores\":$CORES,\"ram\":\"$RAM\",\"disk\":\"$DISK\",\"hostname\":\"$HOSTNAME\"}}"
