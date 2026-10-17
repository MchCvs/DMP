#!/bin/bash
LAST_BOOT=$(stat /var/log/apt/history.log 2>/dev/null | grep Modify | cut -d' ' -f2-3 || echo "Inconnu")
CHANGES=$(grep "apt-get install\|apt-get remove" /var/log/apt/history.log 2>/dev/null | wc -l)
echo "{\"comprendre\":\"Historique = se souvenir de ce qui s'est passé. Comme un journal intime de votre ordinateur.\",\"observations\":\"Dernière modification système: $LAST_BOOT | Nombre de changements: $CHANGES (installations/suppressions)\",\"resultat\":\"Historique complet\",\"informations_techniques\":{\"cmd\":\"/var/log/apt/history.log (DMP uniquement)\",\"last_change\":\"$LAST_BOOT\",\"total_changes\":$CHANGES,\"note\":\"Cet historique sert à tracer les modifications. Utile si quelque chose s'est cassé\"}}"
