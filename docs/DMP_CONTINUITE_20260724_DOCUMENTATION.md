# DMP — Document de continuité
## État du projet au 24 juillet 2026

---

# Objet du document

Ce document constitue le point officiel de reprise du projet
**Debian Maintenance Professionnel (DMP)**.

Il présente l'état validé du projet, les décisions structurantes,
les documents de référence et la méthode permettant de poursuivre
son évolution tout en respectant sa philosophie.

Ce document ne remplace pas les documents spécialisés du projet.
Il sert de guide d'orientation permettant de retrouver rapidement
le contexte, les choix réalisés et les prochaines étapes possibles.

---

# 1. Identité du projet

**Debian Maintenance Professionnel (DMP)**

DMP est un projet destiné à accompagner les utilisateurs Debian
dans la compréhension, la maintenance et l'évolution de leur système.

Le projet privilégie :
- la compréhension avant l'automatisation ;
- la vérification avant l'intégration ;
- la documentation avant l'évolution ;
- la méthode plutôt que l'improvisation.

---

# Les invariants du projet

Les principes suivants constituent les bases durables de DMP :

- La compréhension est privilégiée avant l'automatisation.
- Toute évolution importante doit être documentée.
- Toute modification significative doit être préparée et vérifiée.
- Les jalons représentent des états validés du projet.
- La documentation fait partie intégrante du développement.
- Les solutions simples, reproductibles et compréhensibles sont privilégiées.
- Les décisions importantes doivent rester compréhensibles dans le temps.

Ces principes peuvent évoluer, mais uniquement après réflexion,
documentation et validation.

---

# Chaîne de confiance DMP

Une évolution DMP suit un chemin vérifiable :

Idée
→ Analyse
→ Documentation
→ Préparation
→ Développement
→ Vérification
→ Validation
→ Jalon
→ Archive
→ Continuité

Chaque étape apporte une information nécessaire à la compréhension
et à la pérennité du projet.

---

# 2. État actuel

Version :

DMP 1.7.0

Statut :

Version validée.

Le projet dispose actuellement :
- d'une structure de développement actif ;
- d'une documentation organisée ;
- d'une méthode de développement définie ;
- d'une vision utilisateur validée.

---

# 3. Structure du projet

Emplacement principal :

~/DMP

Organisation :

archives/
documents/
developpement/
projet/
releases/
sauvegardes/
tests/

Principe :

- `developpement/` contient le travail actif ;
- `projet/` conserve les éléments historiques ;
- `documents/` contient la documentation de référence ;
- `sauvegardes/` conserve les états vérifiés.

---

# 4. Documents structurants

Les documents suivants constituent les références principales du projet :

- `README.md`
  Présente l'identité générale du projet et son orientation.

- `PHILOSOPHIE_DMP.md`
  Décrit les principes fondamentaux et les valeurs du projet.

- `README_STRUCTURE_DMP.md`
  Présente l'organisation générale des dossiers et des fichiers.

- `ARCHITECTURE_DMP.md`
  Décrit l'organisation technique du projet.

- `METHODE_DE_DEVELOPPEMENT_DMP.md`
  Définit la méthode de travail et les étapes de validation.

- `DMP_GUIDE_UTILISATEUR.md`
  Présente l'approche destinée aux utilisateurs de DMP.

- `DMP_MODULE_GUIDE.md`
  Explique la conception et l'organisation des modules DMP.

- `DMP_PROCHAINES_EVOLUTIONS.md`
  Présente les pistes d'évolution identifiées pour le projet.

Ces documents forment la base documentaire permettant de comprendre,
maintenir et faire évoluer DMP.

---

# 5. Jalons validés

Les jalons représentent des états vérifiés du projet.
Ils permettent de conserver une référence stable entre plusieurs évolutions.

Chaque jalon associe :
- un état du projet ;
- une documentation de référence ;
- une validation ;
- une archive permettant de retrouver le contexte.

Les jalons importants sont référencés dans :

documents/REGISTRE_JALONS_DMP.md

Jalons actuels :

- `JALON_ORGANISATION_DMP_1.7.0_VALIDE_20260724.md`
- `JALON_VISION_UTILISATEUR_DMP_VALIDE_20260724.md`

Les jalons constituent des points de confiance permettant de poursuivre
l'évolution du projet sans perdre les décisions déjà validées.

---

# 6. Dernière évolution réalisée

Création du registre des jalons DMP.

Archive :

`sauvegardes/DMP_REGISTRE_JALONS_DMP_CREATION_20260724.tar.gz`

Cette évolution apporte une mémoire structurée des décisions validées
et permet de relier les différentes étapes importantes du projet.

Le registre devient un point d'accès central pour retrouver
les jalons et leur contexte documentaire.

---

# 7. Méthode de travail DMP

Le développement suit le cycle :

Observer  
→ Comprendre  
→ Sauvegarder  
→ Préparer  
→ Vérifier  
→ Intégrer  
→ Tester  
→ Archiver

Cette méthode garantit que chaque évolution est préparée,
contrôlée et documentée avant de devenir une nouvelle référence du projet.

Elle s'inscrit dans la chaîne de confiance DMP :

Idée
→ Analyse
→ Documentation
→ Préparation
→ Développement
→ Vérification
→ Validation
→ Jalon
→ Archive
→ Continuité

---

# 8. Principes de continuité

Toute reprise du projet doit commencer par une vérification
de l'état actuel et de ses références.

Ordre recommandé :

1. Consulter le document de continuité.
2. Vérifier la version et l'état du projet.
3. Consulter les documents de référence.
4. Consulter le registre des jalons.
5. Vérifier les archives disponibles.
6. Préparer toute modification avant intégration.

La continuité DMP repose sur plusieurs principes :

- Ne pas modifier un élément important sans comprendre son rôle.
- Conserver une trace des états précédents.
- Vérifier les changements avant validation.
- Préserver la cohérence entre code, documentation et archives.
- Permettre à une nouvelle reprise du projet de retrouver rapidement
  son contexte.

La continuité ne consiste pas à figer DMP,
mais à permettre son évolution sans perdre les connaissances acquises.

---

# 9. Situation actuelle

DMP est dans une phase de consolidation documentaire.

L'état actuel repose sur :

- une version DMP 1.7.0 validée ;
- une organisation de développement actif ;
- une documentation structurée ;
- une vision utilisateur intégrée ;
- un système de jalons validés ;
- un registre permettant de retrouver les références du projet ;
- une documentation de continuité permettant la reprise.

La prochaine évolution devra partir de cet état validé,
en respectant la méthode et les principes définis dans ce document.


