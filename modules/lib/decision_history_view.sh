
#!/bin/bash

# ----------------------------------------------
# Vue historique des décisions DMP
# ----------------------------------------------


show_decision_history()
{

    if [ ! -f "$DECISION_HISTORY_FILE" ]; then

        echo ""
        echo "Aucune décision DMP enregistrée."
        echo ""

        return

    fi


    echo ""
    echo "=============================================="
    echo " Historique des décisions DMP"
    echo "=============================================="
    echo ""


    tail -n +2 "$DECISION_HISTORY_FILE" | tail -n 5 | \
    while IFS=',' read -r DATE ETAT CONFIANCE RECOMMANDATION DECISION RAISON
    do

        echo "Date : ${DATE//\"/}"
        echo "État : ${ETAT//\"/}"
        echo "Confiance : ${CONFIANCE//\"/}"
        echo "Recommandation : ${RECOMMANDATION//\"/}"
        echo "Décision : ${DECISION//\"/}"
        echo "Raison : ${RAISON//\"/}"
        echo ""

    done

}


