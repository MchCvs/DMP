# Méthode de développement DMP

## Debian Maintenance Professionnel (DMP)

**Version : 1.0**  
**Date : 24 juillet 2026**  
**Auteur : Thierry CHEVASSUS**  
**Origine : La Réunion, France**

---

# 1. Objet du document

## 1.1 Rôle de la méthode

Ce document décrit la méthode officielle utilisée pour faire évoluer le projet DMP.

Il ne décrit pas l'architecture technique du logiciel.

Il explique comment préparer, réaliser, vérifier et documenter les évolutions du projet.

L'objectif est de garantir une évolution :

- maîtrisée ;
- compréhensible ;
- reproductible ;
- respectueuse de l'esprit DMP.

---

# 2. Les principes fondamentaux DMP

Le développement DMP repose sur plusieurs principes essentiels.

## Comprendre avant d'agir

Avant toute modification, il est nécessaire de comprendre :

- l'état actuel du projet ;
- le rôle des fichiers concernés ;
- les conséquences possibles d'une évolution.

Une action réalisée sans compréhension peut créer des problèmes difficiles à identifier.

---

## Vérifier avant de valider

Une modification n'est considérée comme terminée qu'après vérification.

La validation repose sur :

- des contrôles ;
- des tests ;
- l'observation des résultats.

---

## Préserver l'existant

Chaque évolution doit respecter le travail déjà réalisé.

Avant une modification importante :

- une sauvegarde est créée ;
- l'état initial est conservé ;
- un retour arrière reste possible.

---

## Favoriser la reproductibilité

Toute amélioration importante du projet doit pouvoir être reproduite par une personne qui n'a pas participé à sa création.

Une bonne méthode doit être transmissible.

---

# 3. Le cycle d'une évolution DMP

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
Vérifier
   ↓
Intégrer
   ↓
Tester
   ↓
Archiver


---

# 4. Les principes de vérification DMP

La vérification est une étape essentielle du développement DMP.

Aucune évolution importante ne doit être considérée comme terminée sans contrôle préalable.

La méthode DMP privilégie :

- l'observation avant l'action ;
- la vérification avant la validation ;
- la compréhension avant l'automatisation.

---

# 5. La préparation d'une évolution

Avant toute modification importante :

- l'état actuel du projet est identifié ;
- une sauvegarde est réalisée ;
- les modifications sont préparées dans un espace adapté.

La préparation permet de limiter les risques et de conserver un historique clair.

---

# 6. L'intégration contrôlée

Une modification validée est ensuite intégrée au projet.

L'intégration doit rester :

- comprise ;
- documentée ;
- vérifiable ;
- réversible si nécessaire.

Une évolution ne doit jamais devenir une modification inconnue du système.

---

# 7. La documentation comme élément du développement

Dans DMP, la documentation n'est pas une étape secondaire.

Elle permet de transmettre :

- le fonctionnement ;
- les choix réalisés ;
- les raisons d'une évolution ;
- la méthode utilisée pour la validation.

Un projet durable doit pouvoir être compris par d'autres personnes.

---

# 8. La reproductibilité

Une évolution importante doit pouvoir être reproduite.

La méthode utilisée doit permettre à une autre personne de comprendre :

- ce qui a été fait ;
- pourquoi cela a été fait ;
- comment vérifier le résultat.

La reproductibilité protège la qualité du projet.

---

# 9. La boussole DMP

Chaque évolution doit respecter les principes fondamentaux du projet.

Avant d'ajouter une fonctionnalité, il faut se demander :

Cette évolution répond-elle à un besoin réel ?

Cette évolution rend-elle l'utilisation plus claire ?

Cette évolution aide-t-elle l'utilisateur à comprendre ?

Cette évolution respecte-t-elle la stabilité et les valeurs Debian ?

---

# 10. Conclusion

DMP n'est pas construit uniquement avec du code.

Il est construit avec une méthode.

Une méthode qui privilégie :

- la compréhension avant l'action ;
- la vérification avant la validation ;
- la qualité avant la rapidité ;
- la simplicité avant la complexité inutile.

Chaque évolution doit contribuer à construire un outil fiable, compréhensible et durable.

---

Debian Maintenance Professionnel (DMP)

Comprendre.  
Vérifier.  
Accompagner.
