#!/bin/bash

# ==================================================
# DMP — Historique des décisions
# Module : decision_history.sh
# Version : 1.0
#
# Rôle :
#   Conserver les décisions prises par DMP
#
# Philosophie :
#   Une décision DMP doit rester explicable
#   dans le temps.
# ==================================================


DECISION_HISTORY_FILE="$REPORT_DIR/decisions.csv"


# ----------------------------------------------
# Initialisation du journal des décisions
# ----------------------------------------------

init_decision_history()
{

    if [ ! -f "$DECISION_HISTORY_FILE" ]; then

        mkdir -p "$(dirname "$DECISION_HISTORY_FILE")"

        echo "date,etat,confiance,recommandation,decision,raison" \
        > "$DECISION_HISTORY_FILE"

    fi

}




# ----------------------------------------------
# Vérification nécessité sauvegarde décision
# ----------------------------------------------

should_save_decision()
{

    if [ ! -f "$DECISION_HISTORY_FILE" ]; then
        return 0
    fi


    local LAST_LINE
    LAST_LINE=$(tail -n 1 "$DECISION_HISTORY_FILE")



    if [ -z "$LAST_LINE" ]; then
        return 0
    fi


    local LAST_RECOMMENDATION
    LAST_RECOMMENDATION=$(echo "$LAST_LINE" |
        cut -d',' -f4 | tr -d '"')


    local LAST_DECISION
    LAST_DECISION=$(echo "$LAST_LINE" |
        cut -d',' -f5 | tr -d '"')



    if [ "$LAST_RECOMMENDATION" = "$RECOMMENDATION_LEVEL" ] &&
       [ "$LAST_DECISION" = "$DECISION_TITLE" ]; then

        return 1

    fi


    return 0

}


# ----------------------------------------------
# Enregistrement d'une décision DMP
# ----------------------------------------------

save_decision()
{


    should_save_decision

    RESULT=$?


    if [ $RESULT -ne 0 ]; then
        return
    fi


    local DATE_NOW
    DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")

    init_decision_history

    echo "\"$DATE_NOW\",\"$HEALTH\",\"$CONFIDENCE_LEVEL\",\"$RECOMMENDATION_LEVEL\",\"$DECISION_TITLE\",\"$JUSTIFICATION_TITLE\"" \
    >> "$DECISION_HISTORY_FILE"

}


