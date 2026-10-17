# JALON — E1.2 / E1.3 — Cohérence observation → explication

**DMP — Debian Maintenance Professionnel**  
**Version : 1.7.0**  
**Date : 15 septembre 2026**  
**Auteur : Thierry CHEVASSUS**

## Statut

**VALIDÉ TECHNIQUEMENT**

## Objet du jalon

Valider que la page E1.3 « Consulter les explications » explique exactement l’observation produite par E1.2, sans effectuer une seconde mesure indépendante lorsque l’observation de référence est encore valide.

## Mécanisme validé

E1.2 constitue l’observation de référence.

Le serveur DMP conserve cette observation en mémoire pendant un TTL de **30 secondes**.

Pendant cette période :

**E1.2 → snapshot → E1.3**

E1.3 reçoit le snapshot E1.2 par la variable d’environnement `DMP_E1_2_SNAPSHOT` et construit ses explications à partir de cette observation.

Lorsque le TTL de 30 secondes est dépassé, E1.3 provoque une nouvelle collecte E1.2, actualise le snapshot, puis explique cette nouvelle observation.

## Preuves réalisées

### 1. Snapshot encore valide

Une observation E1.2 a été mesurée avec une utilisation CPU de **9 %**.

L’appel immédiat à E1.3 a produit une explication indiquant également **9 %**.

**Résultat : 9 % = 9 %.**

L’identité entre l’observation et l’explication est démontrée.

### 2. Expiration du snapshot

Après une attente de **31 secondes**, E1.3 a renouvelé le snapshot.

La trace temporaire du serveur a confirmé :

`TRACE E1.3 : nouveau snapshot E1.2 après expiration`

puis une nouvelle observation E1.2 avec une utilisation CPU de **6 %**.

E1.3 a ensuite produit une explication indiquant également **6 %**.

**Résultat : 6 % = 6 %.**

Le renouvellement du snapshot et l’explication exacte de la nouvelle observation sont donc démontrés.

## Nettoyage après preuve

La trace temporaire utilisée uniquement pour la preuve d’expiration a été supprimée.

Le `diff` entre `dmp_web_server.py.before-e1-snapshot-trace` et `dmp_web_server.py` est vide après suppression de la trace et de la ligne vide résiduelle.

La syntaxe finale du serveur a été vérifiée avec :

`python3 -m py_compile dmp_web_server.py`

Résultat :

`OK : syntaxe finale du serveur`

## Vérifications finales

- E1.2 produit une observation de référence : **OK**
- E1.3 utilise cette observation pendant le TTL : **OK**
- E1.2 et E1.3 donnent une valeur CPU identique pendant le TTL : **OK**
- Le snapshot expire après 30 secondes : **OK**
- E1.3 provoque une nouvelle observation après expiration : **OK**
- E1.3 explique exactement la nouvelle observation : **OK**
- Trace temporaire supprimée : **OK**
- Syntaxe du serveur : **OK**

## Conclusion

Le mécanisme de cohérence **observation E1.2 → explication E1.3** est techniquement validé.

Cette validation garantit que DMP ne présente pas dans E1.3 une explication portant sur une mesure différente de celle observée dans E1.2 lorsque le snapshot est valide.

Après expiration du snapshot, DMP renouvelle l’observation avant de produire l’explication correspondante.

Ce jalon est désormais figé comme référence de développement pour la poursuite de DMP V2.
