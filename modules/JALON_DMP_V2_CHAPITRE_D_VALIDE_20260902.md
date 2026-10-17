# DMP V2 — JALON DE CONTINUITÉ
# CHAPITRE D — SUIVRE LES ÉVOLUTIONS DE MON SYSTÈME
# DYNAMISATION ET VALIDATION COMPLÈTE
# Version : 2026-09-02
# Statut : VALIDÉ

---

## 1. IDENTIFICATION

Projet : DMP — Debian Maintenance Professional

Version de travail :
DMP V2 — Prototype Web

Chapitre concerné :

D — Suivre les évolutions de mon système

Objectif du chapitre :

Permettre à DMP de présenter les observations historiques,
les évolutions mesurées, leur compréhension, les tendances
éventuelles et les informations techniques correspondantes,
à partir de données réellement collectées sur la machine.

Principe fondamental :

> Comprendre avant d’agir.

Chaîne DMP :

Observation
→ Compréhension
→ Explication
→ Décision utilisateur
→ Action
→ Vérification

---

# 2. STATUT GLOBAL DU CHAPITRE D

Le chapitre D est maintenant entièrement connecté aux données
réelles disponibles dans le système DMP.

Les pages D1 et D2 ont été connectées à des collecteurs
non interactifs et en lecture seule.

Les données présentées dans l'interface ne sont plus des valeurs
statiques lorsqu'une source historique exploitable existe.

Les informations indisponibles restent explicitement présentées
comme indisponibles.

Aucune donnée absente n'est remplacée artificiellement par zéro,
une valeur par défaut ou une conclusion supposée.

---

# 3. ARCHITECTURE DU CHAPITRE D

Structure validée :

d-menu.html

D1 :

d1-1-observations.html
d1-2-actions.html
d1-3-resultats.html
d1-4-technique.html

D2 :

d2-1-evolutions.html
d2-2-comprendre.html
d2-3-tendances.html
d2-4-technique.html

Cette structure est VALIDÉE.

Aucune modification structurelle supplémentaire n'est nécessaire
dans le cadre de cette étape.

---

# 4. SOURCES HISTORIQUES VALIDÉES

## 4.1 Historique général des observations

Source :

~/Projets/dmp/reports/history.csv

Format :

Date;Score;Temperature_CPU;RAM_disponible;Disque_utilise;Boot

Nombre d'observations lors de la validation :

18

Les champs réellement exploitables pour D1 et D2 sont :

- date ;
- température CPU ;
- RAM disponible ;
- disque utilisé ;
- temps de démarrage.

Le champ Score est actuellement N/A dans les observations historiques.

Cette absence n'empêche pas les traitements D1/D2 qui ne nécessitent
pas le score.

---

# 5. D1 — HISTORIQUE DU SYSTÈME

## D1.1 — Consulter les observations

Fichier :

d1-1-observations.html

Collecteur :

~/DMP/developpement/dmp/d1_data.sh

API :

/api/d1

Source :

~/Projets/dmp/reports/history.csv

Données présentées :

- dernière observation ;
- date ;
- éléments réellement observés ;
- température CPU ;
- RAM disponible ;
- disque utilisé ;
- temps de démarrage ;
- nombre d'observations ;
- source technique.

Dernière observation connue lors de la validation :

2026-08-19 20:30

Résultat :

D1.1 VALIDÉE

Principe respecté :

Les éléments présentés correspondent aux mesures réellement
disponibles dans l'historique DMP.

---

## D1.2 — Consulter les actions réalisées

Fichier :

d1-2-actions.html

Collecteur :

~/DMP/developpement/dmp/d1_2_data.sh

API :

/api/d1_2

Décision importante :

DMP ne possède actuellement pas de registre général fiable
des actions réellement exécutées.

Les fichiers suivants ne doivent PAS être utilisés comme faux
historique des actions :

- optimisation.log ;
- decisions.csv ;
- history.csv.

En particulier :

optimisation.log

a été explicitement écarté.

DMP ne doit pas transformer une recommandation, une décision
ou une analyse en action réellement exécutée.

Résultat actuel :

Action historique générale :
Information indisponible

Le message présenté par DMP :

Aucune action historique générale n'est actuellement enregistrée
par DMP.

Cette réponse est volontairement honnête.

Aucun journal artificiel n'a été créé pour remplir la page.

Résultat :

D1.2 VALIDÉE

---

## D1.3 — Consulter les résultats précédents

Fichier :

d1-3-resultats.html

Collecteur :

~/DMP/developpement/dmp/d1_3_data.sh

API :

/api/d1_3

Source :

~/Projets/dmp/reports/rapport_DMP_*.txt

Nombre de rapports lors de la validation :

10

Dernier rapport :

rapport_DMP_2026-08-19_20-33-37.txt

Dernière date connue :

mer. 19 août 2026 20:33:37 +04

Le rapport contient les observations et résultats de l'analyse.

Aucune conclusion DMP explicite n'est enregistrée dans les rapports.

Par conséquent :

Conclusion DMP :
Information indisponible

DMP ne doit pas inventer une conclusion à partir du contenu
du rapport.

Résultat :

D1.3 VALIDÉE

---

## D1.4 — Informations techniques

Fichier :

d1-4-technique.html

Collecteur :

~/DMP/developpement/dmp/d1_4_data.sh

API :

/api/d1_4

Principe :

D1.4 agrège les informations produites par :

d1_data.sh
d1_2_data.sh
d1_3_data.sh

Informations présentées :

- historique des observations ;
- disponibilité de l'historique des actions ;
- historique des rapports ;
- dernier résultat ;
- conclusion enregistrée ;
- sources utilisées.

Résultat :

D1.4 VALIDÉE

---

# 6. D2 — ÉVOLUTIONS DU SYSTÈME

## D2.1 — Voir les évolutions

Fichier :

d2-1-evolutions.html

Collecteur :

~/DMP/developpement/dmp/d2_1_data.sh

API :

/api/d2_1

Source :

~/Projets/dmp/reports/history.csv

Principe :

DMP compare exactement les deux dernières observations
réellement enregistrées.

Lors de la validation :

Observation précédente :

2026-08-18 17:36

Observation actuelle :

2026-08-19 20:30

Température :

30.0 → 38.0 °C

RAM disponible :

5,9Gi → 4,2Gi

Disque utilisé :

6% → 6%

Démarrage :

32.895s → 34.061s

Écart température :

8.0 °C

Écart démarrage :

1.166 s

DMP présente ces différences comme des mesures.

Une évolution mesurée n'est pas automatiquement considérée
comme un problème ou une amélioration.

Résultat :

D2.1 VALIDÉE

---

## D2.2 — Comprendre les changements

Fichier :

d2-2-comprendre.html

API utilisée :

/api/d2_1

D2.2 réutilise les données réellement comparées par D2.1.

Informations présentées :

- élément concerné ;
- changement mesuré ;
- valeurs précédente et actuelle ;
- interprétation disponible.

Principe essentiel :

DMP constate les variations mesurées mais ne prétend pas
en établir la cause lorsque les données disponibles ne permettent
pas de le faire.

Phrase validée :

DMP constate les variations mesurées, mais ne peut pas établir
leur cause à partir de ces seules observations.

Résultat :

D2.2 VALIDÉE

---

## D2.3 — Identifier les tendances

Fichier :

d2-3-tendances.html

Collecteur :

~/DMP/developpement/dmp/d2_3_data.sh

API :

/api/d2_3

Source :

~/Projets/dmp/reports/history.csv

Nombre d'observations disponibles lors de la validation :

18

Règle retenue :

Une tendance actuelle est recherchée à partir des trois dernières
observations comparables.

Deux transitions récentes sont donc comparées.

Une tendance n'est présentée que lorsqu'une même direction
est suffisamment répétée.

Une seule variation ne suffit pas.

Résultat lors de la validation :

Tendance établie :

Aucune tendance établie

Élément :

Aucun élément ne présente actuellement une tendance établie

Évolution :

Les trois dernières observations ne confirment pas une direction
suffisamment répétée.

Observations examinées :

2026-08-18 11:00
2026-08-18 17:36
2026-08-19 20:30

Transitions comparées :

2

Principe fondamental :

DMP ne transforme pas des fluctuations en tendance artificielle.

DMP ne transforme pas une tendance éventuelle en diagnostic.

DMP n'invente pas de cause.

Résultat :

D2.3 VALIDÉE

---

## D2.4 — Informations techniques

Fichier :

d2-4-technique.html

API utilisée :

/api/d2_3

D2.4 réutilise le résultat technique produit par le collecteur D2.3.

Les informations techniques affichées comprennent notamment :

- nombre d'observations disponibles ;
- nombre d'observations examinées ;
- nombre de transitions comparées ;
- dates des observations ;
- tendance établie ou absence de tendance ;
- élément concerné ;
- source.

Résultat :

D2.4 VALIDÉE

---

# 7. COLLECTEURS DYNAMIQUES CRÉÉS

Les collecteurs suivants ont été créés ou intégrés pour le chapitre D :

~/DMP/developpement/dmp/d1_data.sh
~/DMP/developpement/dmp/d1_2_data.sh
~/DMP/developpement/dmp/d1_3_data.sh
~/DMP/developpement/dmp/d1_4_data.sh
~/DMP/developpement/dmp/d2_1_data.sh
~/DMP/developpement/dmp/d2_3_data.sh

Tous les collecteurs concernés sont :

- non interactifs ;
- destinés à l'interface web ;
- en lecture seule ;
- basés sur des sources DMP réelles ;
- testables indépendamment de l'interface.

---

# 8. API WEB

Serveur :

~/DMP-V2-web/dmp_web_server.py

Les collecteurs D1 et D2 concernés ont été enregistrés
dans la table COLLECTORS.

APIs validées :

/api/d1
/api/d1_2
/api/d1_3
/api/d1_4
/api/d2_1
/api/d2_3

Les tests API ont confirmé la production de JSON valides.

---

# 9. PRINCIPE DE VÉRACITÉ DES DONNÉES

Le chapitre D applique les règles suivantes :

1. Une donnée réellement disponible est affichée.
2. Une donnée absente reste « Information indisponible ».
3. Une absence de donnée ne devient jamais zéro.
4. Une recommandation n'est jamais considérée comme une action.
5. Une décision n'est jamais considérée comme une action exécutée.
6. Une variation n'est jamais automatiquement un problème.
7. Une variation n'est jamais automatiquement une amélioration.
8. Une tendance n'est établie que lorsque les observations
   permettent raisonnablement de la confirmer.
9. Une cause n'est pas inventée.
10. Une conclusion absente reste absente.

---

# 10. VALIDATIONS UX

Les règles UX générales DMP restent applicables.

Structure des pages :

COMPRENDRE

INFORMATIONS COMPLÉMENTAIRES

INFORMATIONS TECHNIQUES COMPLÉMENTAIRES

Principe :

L'utilisateur doit comprendre le résultat avant d'accéder
aux informations techniques.

Les informations techniques restent disponibles pour consultation
mais ne doivent pas être présentées comme des actions à exécuter
lorsqu'elles sont destinées au moteur DMP.

---

# 11. VALIDATION FINALE DU CHAPITRE D

D1.1 — VALIDÉE

D1.2 — VALIDÉE

D1.3 — VALIDÉE

D1.4 — VALIDÉE

D2.1 — VALIDÉE

D2.2 — VALIDÉE

D2.3 — VALIDÉE

D2.4 — VALIDÉE

---

# 12. STATUT

CHAPITRE D — VALIDÉ

Le chapitre D est considéré comme terminé pour cette étape.

Les pages D1 et D2 sont connectées aux sources historiques
réelles disponibles.

Les résultats affichés dans le prototype web correspondent
aux résultats réellement produits par les collecteurs DMP
au moment de la validation.

Aucune action automatique n'a été introduite.

Aucune donnée manquante n'a été masquée.

Aucune conclusion non établie n'a été inventée.

---

# 13. RÈGLE DE REPRISE

Les décisions validées dans ce jalon sont acquises.

Ne pas remettre en question :

- la structure D1/D2 ;
- les sources historiques retenues ;
- l'exclusion de optimisation.log comme historique d'actions ;
- l'absence volontaire de faux journal d'actions ;
- la distinction observation / évolution / tendance ;
- la règle de prudence sur les tendances ;
- la distinction entre mesure et interprétation ;
- la règle « Information indisponible » ;
- la connexion dynamique des pages validées.

Toute évolution ultérieure doit apporter une information nouvelle
ou répondre à un besoin démontré.

Les audits redondants ne sont pas nécessaires.

---

# 14. PROCHAINE ÉTAPE

Chapitre D terminé.

Poursuivre avec le chapitre suivant du prototype DMP V2.

Méthode à conserver :

1. Identifier la page.
2. Identifier sa source réelle.
3. Sauvegarder avant modification.
4. Créer ou réutiliser le collecteur approprié.
5. Tester le collecteur.
6. Connecter l'API.
7. Connecter la page.
8. Vérifier la structure.
9. Tester dans Firefox.
10. Valider explicitement.
11. Mettre à jour le jalon.

---

# FIN DU JALON

DMP V2
CHAPITRE D — SUIVRE LES ÉVOLUTIONS DE MON SYSTÈME

STATUT FINAL :
VALIDÉ
