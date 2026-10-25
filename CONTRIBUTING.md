# Contribuer à DMP

Merci de vouloir améliorer Debian Maintenance Professionnel !

## Comment commencer

1. **Fork** le dépôt sur GitHub.
2. **Clone** ta copie : `git clone https://github.com/tonnom/DMP.git`
3. **Branche** : `git checkout -b fix/bugname` ou `git checkout -b feature/newname`
4. **Commits** : messages clairs et concis.
5. **Push** et **Pull Request** vers `main`.

## Avant de soumettre

- Teste sur Debian 12/13.
- Vérifie `lintian` si c'est du paquet : `lintian dmp_*.changes`.
- Pas de fichiers générés (`*.pyc`, `debian/dmp/`, etc.).
- Documente tes changements si c'est une nouvelle fonctionnalité.

## Domaines d'amélioration

- **Collecteurs** : ajouter des données (réseau, sécurité, etc.) dans `modules/collecteurs/`.
- **Pages web** : améliorer le design ou la clarté dans `web/html/`.
- **Tests** : enrichir les validations dans `modules/tests/`.
- **Documentation** : rendre le code plus lisible.
- **Traduction** : améliorer ou ajouter des langues dans `i18n-pilote`.

## Questions ?

Ouvre une **issue** sur GitHub. Un mainteneur te répondra.

Merci !
