# Politique de sauvegarde et de jalonnement DMP

## Objectif

DMP distingue deux catégories de sauvegardes afin de répondre à deux besoins différents :

- préserver un état complet du projet ;
- préserver les décisions structurantes du projet.

Ces deux catégories sont complémentaires.

---

# 1. Archives complètes

Une archive complète représente un instantané intégral du projet à une date donnée.

Elle permet de restaurer un état complet du développement.

Elle peut contenir :

- le code source ;
- la documentation ;
- les tests ;
- les scripts ;
- les ressources du projet ;
- les fichiers de configuration.

Objectifs :

- restauration complète ;
- reprise du développement ;
- conservation historique ;
- protection contre la perte de données.

Exemple :

DMP_V2_ARCHITECTURE_COMPLETE_20260805_1643.tar.gz

---

# 2. Jalons validés

Un jalon validé représente une décision importante officiellement validée.

Il ne cherche pas à sauvegarder l'intégralité du projet.

Il constitue une référence documentaire et décisionnelle.

Objectifs :

- figer une étape importante ;
- conserver les choix d'architecture ;
- préserver la philosophie du projet ;
- faciliter les audits ;
- assurer la traçabilité des décisions.

Exemple :

DMP_JALON_REFERENTIEL_FONDATIONS_CYCLE1_VALIDE_20260803.tar.gz

DMP_JALON_ARCHITECTURE_FONDATRICE_V2_COMPLETE_20260805.tar.gz

---

# Différence fondamentale

Archives complètes

- restaurer un état complet du projet ;
- reprendre le développement ;
- sauvegarder tous les fichiers.

Jalons validés

- figer une étape majeure ;
- préserver les décisions ;
- constituer le référentiel historique du projet.

---

# Principe de gouvernance

Une archive complète peut être réalisée à tout moment.

Un jalon validé n'est créé qu'après validation explicite d'une étape structurante.

---

# Règle permanente DMP

Une archive protège le travail réalisé.

Un jalon protège les décisions qui donnent sa cohérence au projet.
