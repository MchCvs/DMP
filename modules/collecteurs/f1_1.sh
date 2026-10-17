#!/bin/bash
ERRORS=$(dmesg 2>/dev/null | grep -i error | wc -l)
echo "{\"comprendre\":\"Contrôle = vérifier s'il y a des problèmes cachés. Comme faire une inspection avant d'acheter une maison.\",\"observations\":\"Erreurs système détectées: $ERRORS (si zéro: excellent)\",\"resultat\":\"$([[ $ERRORS -eq 0 ]] && echo 'Aucun probleme' || echo 'Erreurs a examiner')\",\"informations_techniques\":{\"cmd\":\"dmesg (DMP uniquement)\",\"errors\":$ERRORS}}"
