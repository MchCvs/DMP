
#!/bin/bash

# ----------------------------------------------
# Validation des décisions DMP
# ----------------------------------------------


validate_previous_decision()
{

    echo ""
    echo "=============================================="
    echo " Validation décision DMP"
    echo "=============================================="
    echo ""


    if [ ! -f "$DECISION_HISTORY_FILE" ]; then

        echo "Aucune décision précédente disponible."
        echo ""

        return

    fi


    local LAST_LINE
    LAST_LINE=$(tail -n 1 "$DECISION_HISTORY_FILE")


    local LAST_STATE
    LAST_STATE=$(echo "$LAST_LINE" | cut -d',' -f2 | tr -d '"')


    local LAST_CONFIDENCE
    LAST_CONFIDENCE=$(echo "$LAST_LINE" | cut -d',' -f3 | tr -d '"')


    local LAST_RECOMMENDATION
    LAST_RECOMMENDATION=$(echo "$LAST_LINE" | cut -d',' -f4 | tr -d '"')


    local LAST_DECISION
    LAST_DECISION=$(echo "$LAST_LINE" | cut -d',' -f5 | tr -d '"')


    echo "Décision analysée :"
    echo ""
    echo "$LAST_DECISION"
    echo ""


    echo "Éléments de vérification :"
    echo ""


    echo "✓ État enregistré : $LAST_STATE"

    echo "✓ Niveau de confiance : $LAST_CONFIDENCE"

    echo "✓ Recommandation enregistrée : $LAST_RECOMMENDATION"


    echo ""


    if [ "$LAST_STATE" = "EXCELLENT" ] &&
       [ "$LAST_RECOMMENDATION" = "NIVEAU 1" ]; then


        echo "Conclusion :"
        echo ""

        echo "Décision confirmée."

        echo ""

        echo "La décision précédente reste cohérente"
        echo "avec les informations disponibles."


    else


        echo "Conclusion :"
        echo ""

        echo "La décision reste cohérente avec les informations disponibles."
        echo ""
        echo "Une nouvelle analyse sera réalisée si de nouvelles mesures"
        echo "ou une évolution du système apparaissent."


    fi


}


