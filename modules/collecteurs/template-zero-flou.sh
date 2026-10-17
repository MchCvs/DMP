#!/bin/bash
# RÈGLE DMP: JAMAIS FLOU
# Si pas de données → expliquer POURQUOI
# Si données → expliquer ce que ça VEUT DIRE
# Toujours en langage SIMPLE

# Exemple structure :
# comprendre = "Explication simple pour débutant"
# observations = "Ce qu'on voit + POURQUOI c'est ça"
# resultat = "Interprétation claire"
# informations_techniques = {cmd: "commande utilisée par DMP (INFO UNIQUEMENT)", data: "...", note: "explications si besoin"}

echo "{\"comprendre\":\"...\",\"observations\":\"...\",\"resultat\":\"...\",\"informations_techniques\":{\"cmd\":\"... (DMP uniquement)\",\"data\":\"...\",\"note\":\"Explications supplémentaires si flou possible\"}}"
