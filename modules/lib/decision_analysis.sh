
#!/bin/bash

# ----------------------------------------------
# Analyse historique des décisions DMP
# ----------------------------------------------


analyze_decision_history()
{

    if [ ! -f "$DECISION_HISTORY_FILE" ]; then

        echo ""
        echo "Aucune mémoire décisionnelle disponible."
        echo ""

        return

    fi


    local DECISION_COUNT
    DECISION_COUNT=$(($(wc -l < "$DECISION_HISTORY_FILE") - 1))


    echo ""
    echo "=============================================="
    echo " Analyse mémoire décisionnelle DMP"
    echo "=============================================="
    echo ""

    echo "Nombre de décisions analysées : $DECISION_COUNT"
    echo ""


    if [ "$DECISION_COUNT" -le 0 ]; then

        echo "Observation :"
        echo "Aucune décision enregistrée."
        echo "DMP ne dispose pas encore de référence décisionnelle."

        return

    fi


    local LAST_LINE
    LAST_LINE=$(tail -n 1 "$DECISION_HISTORY_FILE")


    local LAST_RECOMMENDATION
    LAST_RECOMMENDATION=$(echo "$LAST_LINE" | cut -d',' -f4 | tr -d '"')


    local LAST_DECISION
    LAST_DECISION=$(echo "$LAST_LINE" | cut -d',' -f5 | tr -d '"')


    echo "Dernière recommandation :"
    echo "$LAST_RECOMMENDATION"
    echo ""

    echo "Dernière décision :"
    echo "$LAST_DECISION"
    echo ""


    if [ "$DECISION_COUNT" -eq 1 ]; then

        echo "Analyse :"
        echo ""
        echo "Une seule décision est disponible."
        echo "DMP construit actuellement sa référence décisionnelle."

        return

    fi


    local PREVIOUS_LINE
    PREVIOUS_LINE=$(tail -n 2 "$DECISION_HISTORY_FILE" | head -n 1)


    local PREVIOUS_RECOMMENDATION
    PREVIOUS_RECOMMENDATION=$(echo "$PREVIOUS_LINE" | cut -d',' -f4 | tr -d '"')


    echo "Recommandation précédente :"
    echo "$PREVIOUS_RECOMMENDATION"
    echo ""


    if [ "$LAST_RECOMMENDATION" = "$PREVIOUS_RECOMMENDATION" ]; then

        echo "Analyse :"
        echo ""
        echo "DMP constate une stabilité décisionnelle."
        echo ""
        echo "Les dernières recommandations sont identiques."
        echo "La stratégie de maintenance reste cohérente."

    else

        echo "Analyse :"
        echo ""
        echo "DMP détecte un changement de recommandation."
        echo ""
        echo "Ancienne recommandation :"
        echo "$PREVIOUS_RECOMMENDATION"
        echo ""
        echo "Nouvelle recommandation :"
        echo "$LAST_RECOMMENDATION"

    fi


}




# ----------------------------------------------
# Analyse de stabilité décisionnelle DMP
# ----------------------------------------------

analyze_decision_stability()
{

    if [ ! -f "$DECISION_HISTORY_FILE" ]; then

        echo ""
        echo "Aucune mémoire décisionnelle disponible."
        echo ""

        return

    fi


    local COUNT
    COUNT=$(($(wc -l < "$DECISION_HISTORY_FILE") - 1))


    echo ""
    echo "=============================================="
    echo " Stabilité décisionnelle DMP"
    echo "=============================================="
    echo ""


    echo "Décisions analysées : $COUNT"
    echo ""


    if [ "$COUNT" -le 1 ]; then

        echo "Analyse :"
        echo ""
        echo "Historique insuffisant pour établir une tendance."
        echo "DMP construit sa référence décisionnelle."

        return

    fi


    local LEVEL1
    local LEVEL2
    local LEVEL3


    LEVEL1=$(grep -c 'NIVEAU 1' "$DECISION_HISTORY_FILE")
    LEVEL2=$(grep -c 'NIVEAU 2' "$DECISION_HISTORY_FILE")
    LEVEL3=$(grep -c 'NIVEAU 3' "$DECISION_HISTORY_FILE")


    echo "Répartition des recommandations :"
    echo ""
    echo "NIVEAU 1 : $LEVEL1"
    echo "NIVEAU 2 : $LEVEL2"
    echo "NIVEAU 3 : $LEVEL3"
    echo ""


    if [ "$LEVEL1" -gt "$LEVEL2" ] &&
       [ "$LEVEL1" -gt "$LEVEL3" ]; then

        echo "Conclusion :"
        echo ""
        echo "La recommandation dominante est NIVEAU 1."
        echo "La stratégie DMP reste stable."

    elif [ "$LEVEL2" -gt "$LEVEL1" ] &&
         [ "$LEVEL2" -gt "$LEVEL3" ]; then

        echo "Conclusion :"
        echo ""
        echo "La recommandation dominante est NIVEAU 2."
        echo "DMP maintient une surveillance renforcée."

    else

        echo "Conclusion :"
        echo ""
        echo "Une évolution décisionnelle est observée."
        echo "Une analyse complémentaire est nécessaire."

    fi

}

