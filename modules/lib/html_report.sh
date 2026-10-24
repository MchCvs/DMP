#!/bin/bash

# ==================================================
# DMP - Dashboard HTML
# Version 1.4.0
# ==================================================

generate_html_report()
{

HTML="$REPORT_DIR/dashboard.html"

DATE=$(date "+%d/%m/%Y à %H:%M")

html_esc(){ printf "%s" "$1" | sed "s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/\"/\&quot;/g"; }
OS=$(html_esc "$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')")
CPU=$(html_esc "$(lscpu | grep -m1 "Nom de modèle" | cut -d: -f2 | xargs)")

case "$CPU" in
    Intel*)
        CPU=$(printf '%s' "$CPU" | sed -E 's/\(R\)//g; s/\(TM\)//g; s/ CPU @.*//')
        ;;
esac
CORES=$(nproc)
RAM=$(free -h | awk '/Mem:/ {print $2}' | sed 's/iB//')
RAM_AVAILABLE=$(free -h | awk '/Mem:/ {print $7}' | sed 's/iB//')

# Domaine Q — Réseau et Connectivité V1

NETWORK_INTERFACE=$(html_esc "$(get_network_active_interface)")
NETWORK_IPV4=$(get_network_ipv4 | head -n 1)
NETWORK_IPV6=$(get_network_ipv6)
NETWORK_GATEWAY=$(get_network_gateway)
NETWORK_DNS=$(html_esc "$(get_network_dns)")
NETWORK_LOCAL_STATUS=$(get_network_local_status)
NETWORK_INTERNET_STATUS=$(get_network_internet_status)

DISK=$(df -h / | awk 'NR==2 {print $5}')
BOOT=$(systemd-analyze 2>/dev/null | sed -n 's/.*= \([0-9.]*\)s.*/\1/p')

if [ -n "$BOOT" ]; then
    BOOT_ROUNDED=$(awk "BEGIN {printf \"%.0f\", $BOOT}")
else
    BOOT_ROUNDED="Indisponible"
fi

HISTORY_FILE="$REPORT_DIR/history.csv"

HISTORY_COUNT=0
HISTORY_FIRST_DATE="Indisponible"
HISTORY_LAST_DATE="Indisponible"
HISTORY_FIRST_BOOT="Indisponible"
HISTORY_LAST_BOOT="Indisponible"
HISTORY_BOOT_DELTA="Indisponible"
HISTORY_MIN_RAM="Indisponible"
HISTORY_MAX_RAM="Indisponible"
HISTORY_LAST_RAM="Indisponible"
HISTORY_AVG_TEMP="Indisponible"
HISTORY_LAST_TEMP="Indisponible"
HISTORY_FIRST_DISK="Indisponible"
HISTORY_LAST_DISK="Indisponible"

# Indicateurs d'évolution

HISTORY_BOOT_STATUS="Indisponible"
HISTORY_RAM_STATUS="Indisponible"
HISTORY_TEMP_STATUS="Indisponible"
HISTORY_DISK_STATUS="Indisponible"

if [ -f "$HISTORY_FILE" ]; then

    HISTORY_COUNT=$(awk 'NR > 1 && NF {count++} END {print count+0}' "$HISTORY_FILE")

    if [ "$HISTORY_COUNT" -gt 0 ]; then

        HISTORY_FIRST_DATE=$(awk -F';' 'NR==2 {print $1}' "$HISTORY_FILE")
        HISTORY_LAST_DATE=$(awk -F';' 'NR>1 && NF {date=$1} END {print date}' "$HISTORY_FILE")

        HISTORY_FIRST_BOOT=$(LC_ALL=C awk -F';' 'NR==2 {gsub(/s/,"",$6); printf "%.3f", $6}' "$HISTORY_FILE")
        HISTORY_LAST_BOOT=$(LC_ALL=C awk -F';' 'NR>1 && NF {gsub(/s/,"",$6); boot=$6} END {printf "%.3f", boot}' "$HISTORY_FILE")

        HISTORY_BOOT_DELTA=$(awk -v first="$HISTORY_FIRST_BOOT" -v last="$HISTORY_LAST_BOOT" \
            'BEGIN {printf "%.1f", first-last}')

        HISTORY_MIN_RAM=$(LC_ALL=C awk -F';' '
            NR>1 && NF {
                gsub(/Gi/,"",$4)
                if (min=="" || $4 < min) min=$4
            }
            END {if (min!="") printf "%.1f Gio", min}
        ' "$HISTORY_FILE")

        HISTORY_MAX_RAM=$(LC_ALL=C awk -F';' '
            NR>1 && NF {
                gsub(/Gi/,"",$4)
                if ($4 > max) max=$4
            }
            END {if (max!="") printf "%.1f Gio", max}
        ' "$HISTORY_FILE")

        HISTORY_LAST_RAM=$(LC_ALL=C awk -F';' '
            NR>1 && NF {
                ram=$4
                gsub(/Gi/,"",ram)
            }
            END {if (ram!="") printf "%.1f Gio", ram}
        ' "$HISTORY_FILE")

        HISTORY_AVG_TEMP=$(LC_ALL=C awk -F';' '
            NR>1 && NF {
                sum += $3
                count++
            }
            END {if (count) printf "%.1f", sum/count}
        ' "$HISTORY_FILE")

        HISTORY_LAST_TEMP=$(LC_ALL=C awk -F';' '
            NR>1 && NF {temp=$3}
            END {if (temp!="") printf "%.0f", temp}
        ' "$HISTORY_FILE")

        HISTORY_FIRST_DISK=$(awk -F';' 'NR==2 {print $5}' "$HISTORY_FILE")
        HISTORY_LAST_DISK=$(awk -F';' 'NR>1 && NF {disk=$5} END {print disk}' "$HISTORY_FILE")

    # ----------------------------------------------
    # Analyse des évolutions historiques
    # ----------------------------------------------

    # Temps de démarrage
    if [ "$HISTORY_BOOT_DELTA" != "Indisponible" ]; then
        HISTORY_BOOT_STATUS=$(awk -v delta="$HISTORY_BOOT_DELTA" '
            BEGIN {
                if (delta > 0) print "AMÉLIORATION"
                else if (delta < 0) print "DÉGRADATION"
                else print "STABLE"
            }
        ')
    fi

    # Mémoire disponible
    if [ "$HISTORY_COUNT" -gt 1 ]; then
        HISTORY_RAM_STATUS="VARIATION SELON L'USAGE"
    fi

    # Température
    HISTORY_TEMP_STATUS=$(LC_ALL=C awk -F';' '
        NR==2 { first=$3 }
        NR>1 && NF { last=$3 }
        END {
            if (first == "" || last == "")
                print "Indisponible"
            else if (last > first + 3)
                print "HAUSSE"
            else if (last < first - 3)
                print "BAISSE"
            else
                print "STABLE"
        }
    ' "$HISTORY_FILE")

    # Espace disque utilisé
    HISTORY_DISK_STATUS=$(LC_ALL=C awk -F';' '
        NR==2 {
            first=$5
            gsub(/%/,"",first)
        }
        NR>1 && NF {
            last=$5
            gsub(/%/,"",last)
        }
        END {
            if (first == "" || last == "")
                print "Indisponible"
            else if (last > first)
                print "AUGMENTATION"
            else if (last < first)
                print "DIMINUTION"
            else
                print "STABLE"
        }
    ' "$HISTORY_FILE")

    fi
fi

TEMP=$(sensors 2>/dev/null |
    grep "Package id 0" |
    awk '{print $4}' |
    tr -d '+')

if [ -z "$TEMP" ]; then
    TEMP="Indisponible"
fi

# ----------------------------------------------
# Construction de l'évolution historique
# ----------------------------------------------

HISTORY_HTML=""

if [ "$HISTORY_COUNT" -eq 0 ]; then

    HISTORY_HTML='
<p>
Aucune mesure historique n’est actuellement disponible.
</p>

<p>
DMP ne peut donc pas comparer l’état actuel
du système avec une mesure précédente.
</p>
'

elif [ "$HISTORY_COUNT" -eq 1 ]; then

    HISTORY_HTML="
<h3>Mesure disponible</h3>

<p>
Une seule mesure historique est actuellement disponible.
</p>

<p>
DMP conserve cette mesure comme point de référence
pour les prochaines comparaisons.
</p>

<h3>Temps de démarrage</h3>

<p>
<span class=\"label\">Mesure :</span>
$HISTORY_FIRST_BOOT secondes
</p>

<h3>Mémoire disponible</h3>

<p>
<span class=\"label\">Mesure :</span>
$HISTORY_LAST_RAM
</p>

<h3>Température du processeur</h3>

<p>
<span class=\"label\">Mesure :</span>
$HISTORY_LAST_TEMP °C
</p>

<h3>Espace disque</h3>

<p>
<span class=\"label\">Mesure :</span>
$HISTORY_LAST_DISK
</p>

<p>
DMP utilisera cette mesure comme référence
lors des prochains relevés.
</p>
"

else

    HISTORY_HTML="
<h3>Temps de démarrage</h3>

<p>
<span class=\"label\">Première mesure :</span>
$HISTORY_FIRST_BOOT secondes
</p>

<p>
<span class=\"label\">Dernière mesure :</span>
$HISTORY_LAST_BOOT secondes
</p>

<p>
Le temps de démarrage a diminué de
${HISTORY_BOOT_DELTA#-} secondes depuis la première mesure.
</p>

<p>
DMP constate une amélioration du temps de démarrage
depuis la première mesure.
</p>

<h3>Mémoire disponible</h3>

<p>
<span class=\"label\">Mémoire disponible minimale :</span>
$HISTORY_MIN_RAM
</p>

<p>
<span class=\"label\">Mémoire disponible maximale :</span>
$HISTORY_MAX_RAM
</p>

<p>
<span class=\"label\">Dernière mesure :</span>
$HISTORY_LAST_RAM
</p>

<p>
DMP constate que la mémoire disponible
varie selon l'utilisation de la machine.
</p>

<h3>Température du processeur</h3>

<p>
<span class=\"label\">Température moyenne :</span>
$HISTORY_AVG_TEMP °C
</p>

<p>
<span class=\"label\">Dernière mesure :</span>
$HISTORY_LAST_TEMP °C
</p>

<p>
DMP constate que la température du processeur
est restée stable depuis la première mesure.
</p>

<h3>Espace disque</h3>

<p>
<span class=\"label\">Première mesure :</span>
$HISTORY_FIRST_DISK
</p>

<p>
<span class=\"label\">Dernière mesure :</span>
$HISTORY_LAST_DISK
</p>

<p>
DMP constate que l'espace disque utilisé est passé
de $HISTORY_FIRST_DISK à $HISTORY_LAST_DISK
depuis la première mesure.
</p>

<p>
DMP surveille cette valeur afin de détecter
une augmentation significative de l'espace utilisé.
</p>

<p>
DMP utilise ces mesures pour détecter
les évolutions significatives du système.
</p>

<p>
Aucune évolution nécessitant actuellement
une intervention n'est identifiée.
</p>
"

fi

# ----------------------------------------------
# Lecture du dernier état de santé mesuré
# ----------------------------------------------

HEALTH_SCORE_FILE="${REPORT_DIR:-${DMP_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/reports}/health_score.txt"

SCORE="N/A"
HEALTH="Indisponible"

if [ -f "$HEALTH_SCORE_FILE" ]; then
    IFS=';' read -r SCORE HEALTH < "$HEALTH_SCORE_FILE"
fi

if [ -z "$SCORE" ]; then
    SCORE="N/A"
fi

if [ -z "$HEALTH" ]; then
    HEALTH="Indisponible"
fi

case "$SCORE" in
    90|9[0-9]|100)
        HEALTH="EXCELLENT"
        ;;
    75|7[5-9]|8[0-9])
        HEALTH="BON"
        ;;
    50|5[0-9]|6[0-9]|74)
        HEALTH="À SURVEILLER"
        ;;
    *)
        HEALTH="INDÉTERMINÉ"
        ;;
esac

ROOT_SOURCE=$(findmnt -no SOURCE / 2>/dev/null)
ROOT_DEVICE=$(lsblk -no PKNAME "$ROOT_SOURCE" 2>/dev/null)

if [ -n "$ROOT_DEVICE" ] && [ -b "/dev/$ROOT_DEVICE" ]; then
    DISK_MODEL=$(html_esc "$(lsblk -ndo MODEL "/dev/$ROOT_DEVICE" 2>/dev/null | xargs)")
else
    DISK_MODEL=""
fi

if [ -z "$DISK_MODEL" ]; then
    DISK_MODEL="Non identifié"
fi

OTHER_DISKS=""

for disk in /dev/sd? /dev/nvme*n1; do
    [ -b "$disk" ] || continue

    NAME=$(lsblk -ndo NAME "$disk" 2>/dev/null)
    MODEL=$(lsblk -ndo MODEL "$disk" 2>/dev/null | xargs)
    SIZE=$(lsblk -ndo SIZE "$disk" 2>/dev/null)
SIZE="${SIZE%G} Gio"

    [ -n "$NAME" ] || continue
    [ -n "$MODEL" ] || MODEL="Modèle non identifié"

    if [ "$NAME" = "$ROOT_DEVICE" ]; then
        continue
    fi

    ROLE="Disque supplémentaire"

    OTHER_DISKS="${OTHER_DISKS}
<h3>$ROLE</h3>
<p>
$(html_esc "$MODEL")
</p>
<p>
<span class="label">Capacité :</span>
$(html_esc "$SIZE")
</p>
"
done

# ----------------------------------------------
# Conclusion dynamique DMP
# ----------------------------------------------

CONCLUSION_MAIN=""

case "$HEALTH" in
    "EXCELLENT")
        CONCLUSION_MAIN="L'état actuel du système est excellent."
        ;;
    "BON")
        CONCLUSION_MAIN="L'état actuel du système est bon."
        ;;
    "À SURVEILLER")
        CONCLUSION_MAIN="L'état actuel du système nécessite une surveillance."
        ;;
    *)
        CONCLUSION_MAIN="L'état actuel du système ne peut pas être déterminé avec certitude."
        ;;
esac

CONCLUSION_EVOLUTION=""
CONCLUSION_HISTORY=""

if [ "$HISTORY_COUNT" -eq 0 ]; then

    CONCLUSION_EVOLUTION=""
    CONCLUSION_HISTORY="Aucune mesure historique n'est disponible pour comparer l'évolution du système."

elif [ "$HISTORY_COUNT" -eq 1 ]; then

    CONCLUSION_EVOLUTION=""
    CONCLUSION_HISTORY="Une seule mesure historique est disponible. DMP la conserve comme référence pour les prochaines comparaisons."

else

    if [ "$HISTORY_BOOT_STATUS" = "AMÉLIORATION" ]; then
        CONCLUSION_EVOLUTION="Le temps de démarrage s'est amélioré depuis la première mesure."
    elif [ "$HISTORY_BOOT_STATUS" = "DÉGRADATION" ]; then
        CONCLUSION_EVOLUTION="Le temps de démarrage s'est dégradé depuis la première mesure."
    fi

    if [ "$HISTORY_BOOT_STATUS" = "DÉGRADATION" ] ||
       [ "$HISTORY_TEMP_STATUS" = "HAUSSE" ]; then
        CONCLUSION_HISTORY="Une évolution nécessitant une surveillance est détectée dans les mesures historiques."
    else
        CONCLUSION_HISTORY="Les mesures historiques disponibles ne font apparaître aucune évolution nécessitant actuellement une intervention."
    fi

fi

CONCLUSION_EVOLUTION_HTML=""

if [ -n "$CONCLUSION_EVOLUTION" ]; then
    CONCLUSION_EVOLUTION_HTML="
<p>
$CONCLUSION_EVOLUTION
</p>
"
fi

CONCLUSION_HISTORY_HTML=""

if [ -n "$CONCLUSION_HISTORY" ]; then
    CONCLUSION_HISTORY_HTML="
<p>
$CONCLUSION_HISTORY
</p>
"
fi


# ----------------------------------------------
# Construction de la synthèse DMP
# ----------------------------------------------

SUMMARY_STATE=""
SUMMARY_EXPLANATION=""
SUMMARY_POSITIVE=""
SUMMARY_WATCH=""

RECOMMENDATION_LEVEL=""
RECOMMENDATION_TITLE=""
RECOMMENDATION_TEXT=""

JUSTIFICATION_TITLE=""
JUSTIFICATION_TEXT=""

DECISION_ANALYSIS_TITLE=""
DECISION_ANALYSIS_TEXT=""

DECISION_TITLE=""
DECISION_TEXT=""

DECISION_CHANGE_TITLE=""
DECISION_CHANGE_TEXT=""

case "$HEALTH" in
    "EXCELLENT")
        SUMMARY_STATE="Votre système est actuellement en excellent état."
        ;;
    "BON")
        SUMMARY_STATE="Votre système fonctionne correctement."
        ;;
    "À SURVEILLER")
        SUMMARY_STATE="Votre système nécessite une surveillance."
        ;;
    *)
        SUMMARY_STATE="L'état actuel du système ne peut pas être déterminé avec certitude."
        ;;
esac


case "$HISTORY_COUNT" in

    0)
        SUMMARY_EXPLANATION="
DMP a analysé l'état actuel de votre machine.

Les contrôles réalisés permettent d'établir un diagnostic actuel,
mais aucune mesure historique n'est encore disponible pour confirmer une évolution."
        ;;

    1)
        SUMMARY_EXPLANATION="
DMP a analysé l'état actuel de votre machine.

Une première mesure historique est disponible.
Elle servira de référence pour les prochaines comparaisons."
        ;;

    *)
        SUMMARY_EXPLANATION="
DMP a analysé l'état actuel de votre machine.

Les contrôles actuels sont comparés aux mesures historiques disponibles.
Cette comparaison permet d'identifier les évolutions significatives du système."
        ;;

esac


if [ "$HISTORY_COUNT" -gt 1 ]; then

    if [ "$HISTORY_BOOT_STATUS" = "AMÉLIORATION" ]; then
        SUMMARY_POSITIVE="${SUMMARY_POSITIVE}
<li>Le temps de démarrage s'est amélioré depuis la première mesure.</li>"
    fi

    if [ "$HISTORY_TEMP_STATUS" = "STABLE" ]; then
        SUMMARY_POSITIVE="${SUMMARY_POSITIVE}
<li>La température du processeur reste stable.</li>"
    fi

    if [ "$HISTORY_DISK_STATUS" = "STABLE" ]; then
        SUMMARY_POSITIVE="${SUMMARY_POSITIVE}
<li>L'espace disque utilisé reste stable.</li>"
    fi

fi


if [ -z "$SUMMARY_POSITIVE" ]; then
    SUMMARY_POSITIVE="
<li>Aucune évolution positive particulière n'est actuellement identifiée.</li>"
fi


if [ "$HISTORY_COUNT" -gt 1 ]; then
    SUMMARY_WATCH="
<li>Les mesures historiques sont disponibles pour continuer le suivi du système.</li>"
else
    SUMMARY_WATCH="
<li>L'historique est encore limité pour établir des comparaisons complètes.</li>"
fi


# ----------------------------------------------
# Calcul du niveau de confiance DMP
# ----------------------------------------------

CONFIDENCE_LEVEL=""
CONFIDENCE_TEXT=""
CONFIDENCE_DETAILS=""

if [ "$HISTORY_COUNT" -eq 0 ]; then

    CONFIDENCE_LEVEL="LIMITÉE"

    CONFIDENCE_TEXT="
Cette analyse repose uniquement sur les contrôles réalisés actuellement.
Aucune mesure historique n'est disponible pour confirmer une évolution."

    CONFIDENCE_DETAILS="
<li>Contrôles système actuels disponibles.</li>
<li>Aucune mesure historique disponible.</li>"

elif [ "$HISTORY_COUNT" -eq 1 ]; then

    CONFIDENCE_LEVEL="CORRECTE"

    CONFIDENCE_TEXT="
Cette analyse repose sur les contrôles actuels
et une mesure historique de référence.

DMP dispose d'un point de comparaison initial,
mais aucune tendance ne peut encore être établie."

    CONFIDENCE_DETAILS="
<li>Contrôles système actuels disponibles.</li>
<li>Une mesure historique de référence disponible.</li>"

elif [ "$HISTORY_COUNT" -le 10 ]; then

    CONFIDENCE_LEVEL="BONNE"

    CONFIDENCE_TEXT="
Cette analyse repose sur les contrôles actuels
et plusieurs mesures historiques.

DMP peut identifier les premières évolutions du système."

    CONFIDENCE_DETAILS="
<li>Contrôles système actuels disponibles.</li>
<li>Plusieurs mesures historiques disponibles.</li>"

else

    CONFIDENCE_LEVEL="ÉLEVÉE"

    CONFIDENCE_TEXT="
Cette analyse repose sur les contrôles réalisés actuellement,
sur un historique suffisant et sur une comparaison entre plusieurs états du système.

DMP dispose d'un niveau de confiance élevé
pour identifier les évolutions significatives."

    CONFIDENCE_DETAILS="
<li>Contrôles système actuels réalisés.</li>
<li>$HISTORY_COUNT mesures historiques disponibles.</li>
<li>Comparaison temporelle entre plusieurs états du système.</li>"

fi



# ----------------------------------------------
# Construction de la recommandation DMP
# ----------------------------------------------

# Seuil de dégradation du temps de démarrage justifiant
# une surveillance renforcée.
#
# Une variation inférieure à ce seuil est considérée comme
# modérée et ne justifie pas à elle seule une modification
# de la recommandation DMP.
BOOT_DEGRADATION_THRESHOLD=10

BOOT_DEGRADATION_SECONDS=0
BOOT_DEGRADATION_DISPLAY="0,0"

if [ "$HISTORY_BOOT_STATUS" = "DÉGRADATION" ] &&
   [ "$HISTORY_BOOT_DELTA" != "Indisponible" ]; then

    BOOT_DEGRADATION_SECONDS=$(LC_ALL=C awk         -v delta="$HISTORY_BOOT_DELTA" '
        BEGIN {
            gsub(",", ".", delta)
            printf "%.1f", -delta
        }')

    BOOT_DEGRADATION_DISPLAY="${BOOT_DEGRADATION_SECONDS//./,}"
fi


# ----------------------------------------------
# Détermination de la recommandation DMP
# ----------------------------------------------

if [ "$HEALTH" = "EXCELLENT" ] &&
   [ "$HISTORY_TEMP_STATUS" != "HAUSSE" ]; then

    if [ "$HISTORY_BOOT_STATUS" = "DÉGRADATION" ]; then

        if LC_ALL=C awk             -v value="$BOOT_DEGRADATION_SECONDS"             -v threshold="$BOOT_DEGRADATION_THRESHOLD" '
            BEGIN {
                exit !(value < threshold)
            }'
        then

            RECOMMENDATION_LEVEL="NIVEAU 1"
            RECOMMENDATION_TITLE="Aucun changement nécessaire"
            RECOMMENDATION_TEXT="
DMP constate que votre système fonctionne dans de bonnes conditions.

Aucune intervention n'est actuellement recommandée.

La dégradation du temps de démarrage mesurée est de
${BOOT_DEGRADATION_DISPLAY} secondes.

Cette valeur reste inférieure au seuil de surveillance renforcée
fixé à ${BOOT_DEGRADATION_THRESHOLD} secondes.

DMP poursuit le suivi historique afin de vérifier l'évolution
de cette mesure."

        else

            RECOMMENDATION_LEVEL="NIVEAU 2"
            RECOMMENDATION_TITLE="Surveillance renforcée recommandée"
            RECOMMENDATION_TEXT="
DMP a identifié une dégradation significative du temps de démarrage.

La dégradation mesurée est de ${BOOT_DEGRADATION_DISPLAY} secondes.

Cette valeur atteint ou dépasse le seuil de surveillance renforcée
fixé à ${BOOT_DEGRADATION_THRESHOLD} secondes.

Aucune action immédiate n'est recommandée.
DMP poursuit les mesures afin de vérifier si cette dégradation se confirme."

        fi

    else

        RECOMMENDATION_LEVEL="NIVEAU 1"
        RECOMMENDATION_TITLE="Aucun changement nécessaire"
        RECOMMENDATION_TEXT="
DMP constate que votre système fonctionne dans de bonnes conditions.

Aucune intervention n'est actuellement recommandée.
DMP recommande de poursuivre le suivi habituel."

    fi

elif [ "$HEALTH" = "BON" ]; then

    RECOMMENDATION_LEVEL="NIVEAU 2"
    RECOMMENDATION_TITLE="Surveillance recommandée"
    RECOMMENDATION_TEXT="
DMP constate que l'état général du système mérite une surveillance.

Aucune action immédiate n'est recommandée.
DMP poursuit les mesures afin de suivre son évolution."

else

    RECOMMENDATION_LEVEL="NIVEAU 3"
    RECOMMENDATION_TITLE="Analyse complémentaire recommandée"
    RECOMMENDATION_TEXT="
DMP a identifié une situation nécessitant une analyse complémentaire.

DMP doit d'abord identifier précisément l'élément concerné
et vérifier qu'une action corrective apporterait un bénéfice.

Aucune intervention n'est réalisée automatiquement."

fi


# ----------------------------------------------
# Construction de la justification DMP
# ----------------------------------------------

JUSTIFICATION_TITLE="Pourquoi cette recommandation ?"

if [ "$RECOMMENDATION_LEVEL" = "NIVEAU 1" ]; then

    JUSTIFICATION_TEXT="
DMP ne recommande aucune intervention actuellement car :

<ul>
<li>L'état général du système est excellent.</li>
<li>Aucune dégradation significative n'est détectée.</li>
<li>Les évolutions observées ne nécessitent pas d'action immédiate.</li>
<li>L'historique disponible permet de continuer le suivi.</li>
</ul>

Décision DMP :
Continuer la surveillance normale du système."

elif [ "$RECOMMENDATION_LEVEL" = "NIVEAU 2" ]; then

    JUSTIFICATION_TEXT="
DMP recommande une surveillance car :

<ul>
<li>Une évolution du système mérite d'être observée.</li>
<li>Aucune intervention immédiate n'apporte actuellement de bénéfice démontré.</li>
<li>Les prochaines mesures permettront de confirmer la tendance.</li>
</ul>

Décision DMP :
Poursuivre l'observation avant toute action."

else

    JUSTIFICATION_TEXT="
DMP recommande une analyse complémentaire car :

<ul>
<li>Une situation nécessitant une attention particulière a été identifiée.</li>
<li>Une intervention pourrait apporter un bénéfice.</li>
<li>L'action doit être expliquée avant d'être réalisée.</li>
</ul>

Décision DMP :
Analyser la situation avant intervention."

fi



# ----------------------------------------------
# Construction de l'analyse décisionnelle DMP
# ----------------------------------------------

DECISION_ANALYSIS_TITLE="Analyse DMP"

DECISION_ANALYSIS_TEXT="
Éléments pris en compte :

<ul>
"

if [ "$HEALTH" = "EXCELLENT" ]; then
    DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
<li>État général du système : excellent.</li>"
fi

if [ "$HISTORY_COUNT" -gt 1 ]; then
    DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
<li>Historique disponible : $HISTORY_COUNT mesures.</li>"
fi

if [ "$HISTORY_BOOT_STATUS" = "AMÉLIORATION" ]; then
    DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
<li>Temps de démarrage : amélioration constatée.</li>"
fi

if [ "$HISTORY_TEMP_STATUS" = "STABLE" ]; then
    DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
<li>Température processeur : stabilité constatée.</li>"
fi

if [ "$HISTORY_DISK_STATUS" = "STABLE" ]; then
    DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
<li>Espace disque : évolution maîtrisée.</li>"
fi

DECISION_ANALYSIS_TEXT="${DECISION_ANALYSIS_TEXT}
</ul>

Conclusion :

Les informations disponibles ne montrent pas de situation nécessitant actuellement une intervention."

# ----------------------------------------------
# Construction de la décision DMP
# ----------------------------------------------

DECISION_CHANGE_TITLE="DMP modifiera cette décision si"

if [ "$RECOMMENDATION_LEVEL" = "NIVEAU 1" ]; then

    DECISION_TITLE="Aucune intervention recommandée actuellement"

    DECISION_TEXT="
DMP considère que la situation actuelle ne nécessite pas d'action.

La décision est basée sur :

<ul>
<li>Un état général du système excellent.</li>
<li>Aucune dégradation significative détectée.</li>
<li>Des mesures historiques permettant un suivi fiable.</li>
<li>Des évolutions observées ne nécessitant pas d'intervention.</li>
</ul>

DMP recommande de poursuivre la surveillance normale du système."

    DECISION_CHANGE_TEXT="
<ul>
<li>Une dégradation durable d'une mesure importante apparaît.</li>
<li>Une évolution inhabituelle est détectée dans l'historique.</li>
<li>Un élément critique nécessite une analyse complémentaire.</li>
</ul>"

elif [ "$RECOMMENDATION_LEVEL" = "NIVEAU 2" ]; then

    DECISION_TITLE="Surveillance renforcée recommandée"

    DECISION_TEXT="
DMP recommande de continuer l'observation avant toute intervention.

Les informations disponibles indiquent une évolution à surveiller."

    DECISION_CHANGE_TEXT="
<ul>
<li>Une tendance négative se confirme.</li>
<li>Une dégradation mesurable apparaît.</li>
<li>Une action apporte un bénéfice clairement identifié.</li>
</ul>"

else

    DECISION_TITLE="Analyse complémentaire recommandée"

    DECISION_TEXT="
DMP recommande une analyse approfondie avant toute intervention."

    DECISION_CHANGE_TEXT="
<ul>
<li>Les nouvelles mesures confirment une anomalie.</li>
<li>L'origine du problème est identifiée.</li>
<li>Une action corrective peut être justifiée.</li>
</ul>"

fi



# ----------------------------------------------
# Construction de la mémoire décisionnelle DMP
# ----------------------------------------------

DECISION_MEMORY_TITLE="Mémoire décisionnelle DMP"
DECISION_MEMORY_TEXT=""

if [ -f "$DECISION_HISTORY_FILE" ]; then

    DECISION_COUNT=$(($(wc -l < "$DECISION_HISTORY_FILE") - 1))

    if [ "$DECISION_COUNT" -le 0 ]; then

        DECISION_MEMORY_TEXT="
DMP ne dispose pas encore de décision enregistrée.
La mémoire décisionnelle sera construite progressivement."

    elif [ "$DECISION_COUNT" -eq 1 ]; then

        LAST_DECISION_LINE=$(tail -n 1 "$DECISION_HISTORY_FILE")

        LAST_DECISION=$(echo "$LAST_DECISION_LINE" |
            cut -d',' -f5 | tr -d '"')

        DECISION_MEMORY_TEXT="
DMP dispose actuellement d'une première décision enregistrée.

Décision mémorisée :

<ul>
<li>$LAST_DECISION</li>
</ul>

Cette décision constitue la référence initiale de suivi."

    else

        LAST_DECISION_LINE=$(tail -n 1 "$DECISION_HISTORY_FILE")

        PREVIOUS_DECISION_LINE=$(tail -n 2 "$DECISION_HISTORY_FILE" |
            head -n 1)

        LAST_RECOMMENDATION=$(echo "$LAST_DECISION_LINE" |
            cut -d',' -f4 | tr -d '"')

        PREVIOUS_RECOMMENDATION=$(echo "$PREVIOUS_DECISION_LINE" |
            cut -d',' -f4 | tr -d '"')

        LAST_DECISION=$(echo "$LAST_DECISION_LINE" |
            cut -d',' -f5 | tr -d '"')

        if [ "$LAST_RECOMMENDATION" = "$PREVIOUS_RECOMMENDATION" ]; then

            DECISION_MEMORY_TEXT="
DMP dispose de plusieurs décisions historiques.

<ul>
<li>$DECISION_COUNT décisions enregistrées.</li>
<li>Dernière recommandation : $LAST_RECOMMENDATION.</li>
<li>La recommandation actuelle reste cohérente avec la précédente.</li>
</ul>

Dernière décision :

<strong>$LAST_DECISION</strong>"

        else

            DECISION_MEMORY_TEXT="
DMP dispose de plusieurs décisions historiques.

<ul>
<li>$DECISION_COUNT décisions enregistrées.</li>
<li>Recommandation précédente : $PREVIOUS_RECOMMENDATION.</li>
<li>Dernière recommandation : $LAST_RECOMMENDATION.</li>
</ul>

DMP a détecté une évolution de sa recommandation.

La recommandation précédente était :
<strong>$PREVIOUS_RECOMMENDATION</strong>

La recommandation actuelle est :
<strong>$LAST_RECOMMENDATION</strong>

Cette évolution est liée aux nouvelles mesures disponibles
et aux changements observés dans l'historique du système.

Dernière décision :

<strong>$LAST_DECISION</strong>

DMP conserve cette décision en attente de nouvelles mesures
afin de confirmer ou d'infirmer cette évolution."

        fi

    fi

else

    DECISION_MEMORY_TEXT="
Aucune mémoire décisionnelle disponible actuellement."

fi


# ----------------------------------------------
# Sauvegarde de la décision DMP
# ----------------------------------------------

save_decision


SUMMARY_HTML="
<h2>Synthèse DMP</h2>

<p>
<strong>$SUMMARY_STATE</strong>
</p>

<h3>Compréhension DMP</h3>

<p>
$SUMMARY_EXPLANATION
</p>

<h3>Confiance DMP dans cette analyse</h3>

<p>
<strong>$CONFIDENCE_LEVEL</strong>
</p>

<p>
$CONFIDENCE_TEXT
</p>

<ul>
$CONFIDENCE_DETAILS
</ul>

<h3>$DECISION_ANALYSIS_TITLE</h3>

<p>
$DECISION_ANALYSIS_TEXT
</p>

<h3>Points observés</h3>

<ul>
$SUMMARY_POSITIVE
</ul>

<h3>Suivi</h3>

<ul>
$SUMMARY_WATCH
</ul>

<h3>Recommandation DMP</h3>

<p>
<strong>$RECOMMENDATION_LEVEL</strong>
</p>

<p>
<strong>$RECOMMENDATION_TITLE</strong>
</p>

<p>
$RECOMMENDATION_TEXT
</p>

<h3>Justification DMP</h3>

<p>
<strong>$JUSTIFICATION_TITLE</strong>
</p>

<p>
$JUSTIFICATION_TEXT
</p>

<h3>Décision DMP</h3>

<p>
<strong>$DECISION_TITLE</strong>
</p>

<p>
$DECISION_TEXT
</p>

<h3>$DECISION_MEMORY_TITLE</h3>

<p>
$DECISION_MEMORY_TEXT
</p>

<h3>$DECISION_CHANGE_TITLE</h3>

<p>
$DECISION_CHANGE_TEXT
</p>
"

cat > "$HTML" <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Rapport DMP — État de santé du système</title>

<style>

body {
    font-family: Arial, sans-serif;
    max-width: 1000px;
    margin: 0 auto;
    padding: 30px;
    background: #f4f4f4;
    color: #222;
    line-height: 1.6;
}

header {
    background: white;
    padding: 30px;
    margin-bottom: 25px;
    border-radius: 12px;
    text-align: center;
}

.card {
    background: white;
    padding: 25px;
    margin: 20px 0;
    border-radius: 12px;
    box-shadow: 0 2px 5px #aaa;
}

h1 {
    margin-top: 0;
}

h2 {
    border-bottom: 1px solid #ddd;
    padding-bottom: 8px;
}

.score {
    font-size: 42px;
    font-weight: bold;
    text-align: center;
    margin: 15px 0;
}

.health {
    text-align: center;
    font-size: 22px;
    font-weight: bold;
}

.label {
    font-weight: bold;
}

.conclusion {
    font-size: 18px;
}

footer {
    text-align: center;
    color: #666;
    margin-top: 30px;
}

</style>
</head>

<body>

<header>
<h1>🐧 Debian Maintenance Professional</h1>

<p>
<strong>Rapport DMP</strong>
</p>

<p>
Généré le : $DATE
</p>

<p>
Version DMP : $DMP_VERSION
</p>
</header>


$SUMMARY_HTML


<div class="card">

<h2>État de santé du système</h2>

<div class="score">
$SCORE / 100
</div>

<div class="health">
$HEALTH
</div>

<p>
Les contrôles réalisés par DMP permettent d'établir
une synthèse de l'état actuel de votre système.
</p>

</div>


<div class="card">

<h2>Votre système</h2>

<p>
<span class="label">Machine :</span>
$(html_esc "$(hostname)")
</p>

<p>
<span class="label">Système :</span>
$OS
</p>

<p>
<span class="label">Noyau :</span>
$(uname -r)
</p>

</div>


<div class="card">

<h2>Réseau et connectivité</h2>

<p>
<span class="label">Interface active :</span>
$NETWORK_INTERFACE
</p>

<p>
<span class="label">Adresse IPv4 :</span>
${NETWORK_IPV4:-Indisponible}
</p>

<p>
<span class="label">Adresses IPv6 :</span><br>
${NETWORK_IPV6:-Indisponible}
</p>

<p>
<span class="label">Passerelle :</span>
${NETWORK_GATEWAY:-Indisponible}
</p>

<p>
<span class="label">Serveurs DNS :</span><br>
${NETWORK_DNS:-Indisponibles}
</p>

<p>
<span class="label">Connexion locale :</span>
$NETWORK_LOCAL_STATUS
</p>

<p>
<span class="label">Accès Internet :</span>
$NETWORK_INTERNET_STATUS
</p>

</div>


<div class="card">

<h2>Votre matériel</h2>

<p>
<span class="label">Processeur :</span>
$CPU
</p>

<p>
<span class="label">Nombre de cœurs :</span>
$CORES
</p>

<p>
<span class="label">Mémoire vive :</span>
$RAM
</p>

<p>
<span class="label">Mémoire disponible :</span>
$RAM_AVAILABLE
</p>

<p>
<span class="label">Température du processeur :</span>
$TEMP
</p>

</div>


<div class="card">

<h2>Vos disques</h2>

<h3>Disque principal Debian</h3>

<p>
$DISK_MODEL
</p>

<p>
<span class="label">Espace utilisé :</span>
$DISK
</p>

<p>
DMP identifie le disque qui contient Debian
et présente son utilisation actuelle.
</p>

$OTHER_DISKS

<p>
DMP présente chaque disque selon le rôle
identifié dans votre système.
</p>

</div>


<div class="card">

<h2>Performances</h2>

<p>
<span class="label">Temps de démarrage</span>
</p>

<p>
${BOOT_ROUNDED} secondes
</p>

<p>
Cette valeur correspond au temps nécessaire
à Debian pour terminer son démarrage.
</p>

<p>
DMP conserve cette mesure afin de pouvoir
suivre son évolution dans le temps.
</p>

</div>


<div class="card">

<h2>Évolution DMP</h2>

<p>
DMP conserve les mesures réalisées au fil du temps.
</p>

<p>
Ces mesures permettent de comparer l'état actuel
de votre système avec les mesures précédentes.
</p>

<h3>Suivi des mesures</h3>

<p>
<span class="label">Nombre de mesures enregistrées :</span>
$HISTORY_COUNT
</p>

$HISTORY_HTML

<h2>Conclusion DMP</h2>

<p>
<strong>$CONCLUSION_MAIN</strong>
</p>

$CONCLUSION_EVOLUTION_HTML
$CONCLUSION_HISTORY_HTML

</div>


<footer>

<p>
Debian Maintenance Professional
</p>

<p>
Créateur : $DMP_AUTHOR<br>
Origine : $DMP_ORIGIN 🇷🇪
</p>

</footer>

</body>
</html>
EOF


echo
echo "=============================================="
echo " Rapport HTML DMP généré"
echo "=============================================="
echo
echo "Le rapport présente l'état de votre système"
echo "dans un format adapté à sa consultation."
echo
echo "Ouverture du rapport..."
xdg-open "$HTML" >/dev/null 2>&1 &

}
