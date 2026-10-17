# DMP — Debian Maintenance Professionnel (DMP)

## README développeur actif

**Version :** 1.7.0  
**Date :** 24 juillet 2026  
**Auteur :** Thierry CHEVASSUS  
**Origine :** La Réunion, France 🇷🇪

---

# 1. Rôle du document

Ce document décrit la méthode de travail utilisée pour le développement actif de DMP.

Il complète le fichier :

README.md

qui présente le projet aux utilisateurs.

Le présent document concerne uniquement :

- l'organisation du développement ;
- les règles d'évolution ;
- les vérifications ;
- la méthode de validation.

---
# 2. Base officielle de développement actif

La base de travail active est :

~/DMP/developpement/dmp/

Cette base constitue la référence pour les futures évolutions.

Elle contient uniquement :

- les fichiers actuellement utilisés ;
- les modules fonctionnels ;
- la documentation active ;
- les éléments nécessaires au développement.

---
# 3. Organisation du projet

Structure générale :

DMP/

├── developpement/dmp/
│   → développement actif

├── documents/
│   → documentation de référence

├── archives/
│   → historique, essais et anciennes versions

└── sauvegardes/
    → points de restauration validés

La séparation entre développement actif et historique garantit un projet lisible, maintenable et transmissible.

---
# 4. Principes fondamentaux DMP

Le développement DMP repose sur plusieurs principes essentiels.

## Comprendre avant d'agir

Avant toute modification :

- identifier l'état actuel du projet ;
- comprendre le rôle des fichiers concernés ;
- évaluer les conséquences possibles.

---

## Vérifier avant de valider

Une évolution n'est considérée comme terminée qu'après :

- contrôles ;
- tests ;
- observation des résultats.

---

## Préserver l'existant

Avant toute modification importante :

- une sauvegarde est réalisée ;
- l'état initial est conservé ;
- un retour arrière reste possible.

---

## Favoriser la reproductibilité

Une évolution doit pouvoir être comprise et reproduite par une autre personne.

---
# 5. Cycle d'une évolution DMP

Toute évolution importante suit un cycle défini.

```text
Observer
   ↓
Comprendre
   ↓
Sauvegarder
   ↓
Préparer
   ↓
Modifier
   ↓
Vérifier
   ↓
Tester
   ↓
Intégrer
   ↓
Archiver
```
Ce cycle permet de conserver une évolution :

- maîtrisée ;
- compréhensible ;
- vérifiable ;
- réversible si nécessaire.

---

# 6. Vérifications avant validation

Avant toute intégration, une évolution doit être vérifiée.

Les contrôles permettent de confirmer :

- que les scripts fonctionnent correctement ;
- que la structure du projet reste cohérente ;
- que les fichiers nécessaires sont présents ;
- que les résultats obtenus correspondent aux attentes.

Les contrôles principaux sont :

./dmp-check.sh

./dmp-check-language.sh

Une évolution n'est considérée comme validée qu'après vérification complète.

---
# 7. Documentation du développement

Dans DMP, la documentation fait partie intégrante du développement.

Elle permet de conserver :

- les choix réalisés ;
- les raisons d'une évolution ;
- les méthodes utilisées ;
- les vérifications effectuées.

Une évolution bien documentée peut être comprise et reprise par une autre personne.

La documentation protège la mémoire du projet et facilite sa transmission.

---
# 8. La boussole DMP

Chaque évolution doit respecter les principes fondamentaux du projet.

Avant d'ajouter une fonctionnalité, il faut se demander :

Cette évolution répond-elle à un besoin réel ?

Cette évolution rend-elle l'utilisation plus claire ?

Cette évolution aide-t-elle l'utilisateur à comprendre ?

Cette évolution respecte-t-elle la stabilité et les valeurs Debian ?

La boussole DMP permet de conserver un projet utile, simple et cohérent.

---
# 9. Conclusion

DMP n'est pas construit uniquement avec du code.

Il est construit avec une méthode.

Une méthode qui privilégie :

- la compréhension avant l'action ;
- la vérification avant la validation ;
- la qualité avant la rapidité ;
- la simplicité avant la complexité inutile.

Chaque évolution doit contribuer à construire un outil fiable, compréhensible et durable.

Debian Maintenance Professionnel (DMP)

Comprendre.  
Vérifier.  
Accompagner.

---
