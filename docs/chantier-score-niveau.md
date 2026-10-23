# Chantier : score fondé sur des niveaux explicites

Statut : à démarrer
Branche : `correctif-score-niveau` (à partir de `main`)

## Problème

La page `web/html/e2.html` calcule la note globale. Pour chaque sujet, elle
classe le texte produit par le collecteur grâce à des expressions régulières
(fonction `niv()`), qui cherchent des mots comme « défaillance », « presque plein »
ou « surveiller ».

Ce mécanisme est fragile :

- il ignore la négation : « Aucune défaillance détectée » est classée en rouge ;
- il dépend de la formulation exacte : un changement de texte modifie la note
  sans qu'aucune mesure ne change ;
- il est dupliqué dans la page, sans test.

Test de référence (`python3`, mêmes motifs) : « Aucune défaillance détectée »,
« Pas de failles de sécurité » et « Vous pouvez agir rapidement si besoin »
sont toutes classées en niveau 2 (rouge).

## Objectif

Chaque collecteur déclare son niveau à partir de sa mesure réelle, dans son JSON :

```json
"niveau": 0
```

Valeurs :

| niveau | signification | affichage | points |
|--------|---------------|-----------|--------|
| 0 | bon état | ✅ | 100 |
| 1 | à surveiller | 🟡 | 60 |
| 2 | à corriger | 🔴 | 20 |
| 3 | sans objet | ➖ | ignoré |

La regex ne sert plus qu'en secours, pour les collecteurs qui n'ont pas encore
été convertis.

## Étapes

1. **Page `e2.html`** : lire `d.niveau` s'il est un entier de 0 à 3, sinon
   retomber sur `niv()`. Aucun collecteur n'est modifié à cette étape.
2. **Fonction commune** dans `modules/collecteurs/lib.sh` : `dmp_niveau N`,
   qui émet le champ `"niveau"` à partir d'une valeur numérique déjà calculée.
3. **Conversion par lots** de 4 ou 5 collecteurs, un lot par commit :
   - lot 1 : a1, a2, a5, a6 (matériel)
   - lot 2 : a3, b4 (stockage)
   - lot 3 : a4, b5 (réseau)
   - lot 4 : b1, b2, b3, b7, b8 (performance)
   - lot 5 : b6, b9, c1, c2, c3 (sécurité et entretien)
4. **Test de concordance** : pour chaque collecteur, comparer le niveau déclaré
   et le niveau que donnait la regex. Les écarts sont à examiner un par un.
5. **Retrait de la regex** : seulement quand les 19 sujets déclarent un niveau.

## Critères de validation

- chaque collecteur produit un JSON valide (test `python3 -m json.tool`) ;
- le champ `niveau` est présent et vaut 0, 1, 2 ou 3 ;
- la note globale ne change pas sans changement de mesure ;
- « Aucune défaillance détectée » donne un niveau 0.

## Hors périmètre

- le fichier `e2.sh`, obsolète (à traiter séparément) ;
- la traduction (branche `i18n-pilote`, à fusionner plus tard).

## Journal

- À compléter au fil des lots.

## Journal

- Lots 1 à 6 commités sur `correctif-score-niveau`.
- Étape 4 : 4 faux positifs regex (a1, a2, a4, b6) confirmés — niveau déclaré correct.
- Aucune correction de collecteur nécessaire.

## Clôture — score à niveaux explicites

- Étapes 1 à 5 : terminées (`30615d7` à `d7c916b`), publiées sur `main` (`42756c0`).
- Pages lisant le niveau déclaré : D1, E1, E5, F1-1 à F1-3, F2, F3-F4 (`9b411e4`).
- Bouton « Chercher » avec retour « en cours » restauré (`c30915f`).
- Phrase E5 sans point à traiter corrigée (`70ffcc6`, fusionnée en `9dbe9f1`).

Reste hors périmètre : `e2.sh` obsolète ; traduction `i18n-pilote` (48 commits, en attente de relecture de l'allemand) ; phrase de B8 « services lents ci-dessus » sans liste visible.
