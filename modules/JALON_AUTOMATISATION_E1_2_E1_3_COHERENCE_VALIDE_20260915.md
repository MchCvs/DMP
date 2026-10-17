# JALON — AUTOMATISATION E1.2 → E1.3

**DMP — Debian Maintenance Professionnel**
**Version : 1.7.0**
**Auteur : Thierry CHEVASSUS**
**Date : 15 septembre 2026**

## Statut

**VALIDÉ TECHNIQUEMENT**

## Objet du jalon

Ce jalon fige la validation de l’automatisation de non-régression de la cohérence entre :

* **E1.2 — Résultats généraux**
* **E1.3 — Explications**

L’objectif est de pouvoir vérifier automatiquement que le mécanisme de transmission et d’utilisation du résultat E1.2 par E1.3 reste fonctionnel après une évolution du code.

## Test automatisé

Script :

`~/DMP/developpement/dmp/test_e1_2_e1_3_coherence.sh`

Le test couvre trois situations distinctes.

### 1. Snapshot valide

E1.2 effectue une observation CPU.

E1.3 utilise le snapshot E1.2 disponible et doit expliquer la même valeur d’utilisation CPU.

Résultat obtenu :

`PASS : Snapshot valide : E1.2 = E1.3 (9)`

### 2. Expiration du snapshot

Le test attend 31 secondes, dépassant le TTL de 30 secondes.

E1.3 doit alors reconstruire une observation E1.2 et produire une explication CPU valide.

Résultat obtenu :

`PASS : Expiration : E1.3 reconstruit une observation CPU (16)`

La valeur mesurée peut naturellement varier d’une exécution à l’autre.

### 3. Redémarrage du serveur

Le serveur DMP est arrêté puis relancé.

E1.3 est appelé directement après le redémarrage et doit produire une observation CPU valide.

Résultat obtenu :

`PASS : Redémarrage : E1.3 produit une nouvelle observation CPU (14)`

## Résultat global

Exécution du test :

```text
==============================================
DMP — Test de cohérence E1.2 → E1.3
==============================================

[1/3] Snapshot valide
PASS : Snapshot valide : E1.2 = E1.3 (9)

[2/3] Expiration du snapshot
ATTENTE : expiration du snapshot (31 secondes)...
PASS : Expiration : E1.3 reconstruit une observation CPU (16)

[3/3] Redémarrage du serveur
ARRÊT : serveur DMP actuel...
RELANCE : serveur DMP...
PASS : Redémarrage : E1.3 produit une nouvelle observation CPU (14)

==============================================
PASS : 3
FAIL : 0
==============================================
```

## Éléments techniques validés

Le test confirme :

1. qu’un snapshot E1.2 valide est correctement réutilisé par E1.3 ;
2. qu’E1.3 ne nécessite pas une seconde mesure lorsque le snapshot est valide ;
3. qu’un snapshot expiré entraîne une nouvelle collecte E1.2 ;
4. qu’E1.3 reste fonctionnel après redémarrage du serveur ;
5. que les valeurs CPU sont comparées comme données mesurées et non comme formulations textuelles différentes ;
6. que l’automatisation peut détecter une incohérence E1.2 → E1.3.

## Principe de non-régression

Toute modification ultérieure du mécanisme E1.2/E1.3 devra préserver les trois scénarios couverts par ce test.

Une modification ne sera considérée comme conforme que si :

`PASS = 3`

et :

`FAIL = 0`

## Conclusion

L’automatisation de non-régression de la cohérence **E1.2 → E1.3** est techniquement validée.

Le mécanisme dispose désormais :

* d’une validation fonctionnelle ;
* d’une validation de l’expiration du snapshot ;
* d’une validation après redémarrage ;
* d’un test automatisé reproductible.

**Ce jalon est figé comme référence technique pour la suite du développement DMP V2.**
