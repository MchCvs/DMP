(function () {
  var L = localStorage.getItem('dmp_lang') || 'fr';
  if (L === 'fr') return;
  fetch('/i18n/' + L + '.json').then(function (r) { return r.json(); }).then(function (d) {
    var PAGES = {'a2':'page.nom.0','a3':'page.nom.1','a4':'page.nom.2','a5':'page.nom.3','a6':'page.nom.4','a7':'page.nom.5','a8':'page.nom.6','a9':'page.nom.7','b1':'page.nom.8','b2':'page.nom.9','b3':'page.nom.10','b4':'page.nom.11','b5':'page.nom.12','b6':'page.nom.13','b7':'page.nom.14','b8':'page.nom.15','b9':'page.nom.16','c1':'page.nom.17','c2':'page.nom.18','c3':'page.nom.19','c4':'page.nom.20','d1':'page.nom.21','d2':'page.nom.22','d3':'page.nom.23','e1-analyse':'page.nom.24','e2-resume':'page.nom.25','e3-score':'page.nom.26','e4-rapport':'page.nom.27','e5-graphiques':'page.nom.28','f1-1':'page.nom.29','f1-2':'page.nom.30','f1-3':'page.nom.31','f2-extensions':'page.nom.32','f3-f4':'page.nom.33','verification-sante':'page.nom.34'};
    var M = {
      'Accueil': 'page.accueil', 'Comprendre': 'page.comprendre', "Ce qu'on voit": 'page.voit',
      'Ce que ça veut dire': 'page.veut', 'Précédent': 'page.precedent', 'Suivant': 'page.suivant',
      'Retour': 'page.retour', 'Infos techniques (pour experts)': 'page.infos', 'A2 Mémoire': 'page.nom.0', 'A3 Disque': 'page.nom.1', 'A4 Réseau': 'page.nom.2', 'A5 Carte graphique': 'page.nom.3', 'A6 Carte-mère': 'page.nom.4', 'A7 Debian': 'page.nom.5', 'A8 USB': 'page.nom.6', 'A9 Alimentation': 'page.nom.7', 'B1 Disponibilité': 'page.nom.8', 'B2 Processeur %': 'page.nom.9', 'B3 Mémoire %': 'page.nom.10', 'B4 Disque %': 'page.nom.11', 'B5 Réseau': 'page.nom.12', 'B6 Services': 'page.nom.13', 'B7 Processus': 'page.nom.14', 'B8 Démarrage': 'page.nom.15', 'B9 Sécurité': 'page.nom.16', 'C1 Mises à jour': 'page.nom.17', 'C2 Paquets': 'page.nom.18', 'C3 Entretien': 'page.nom.19', 'C4 Technique': 'page.nom.20', 'D1 Recherche': 'page.nom.21', 'D2 Suppression': 'page.nom.22', 'D3 Bénéfices': 'page.nom.23', 'E1 Analyse': 'page.nom.24', 'E2 Résumé': 'page.nom.25', 'E3 Score': 'page.nom.26', 'E4 Rapport': 'page.nom.27', 'E5 Graphiques': 'page.nom.28', 'F1-1 Contrôle': 'page.nom.29', 'F1-2 Résultats': 'page.nom.30', 'F1-3 Anomalies': 'page.nom.31', 'F2 Monitoring et sauvegarde': 'page.nom.32', 'F3-F4 Vitesse et historique': 'page.nom.33', 'Vérification santé': 'page.nom.34'
    };
    document.querySelectorAll('a').forEach(function (e) {
      var m = e.textContent.trim().match(/^(Suivant|Précédent) : (.+?)\s*(→|←)$/); if (!m) m = null;
      if (m) {
        var n = M[m[2]];
        var base = m[1] === 'Suivant' ? 'page.suivant' : 'page.precedent';
        if (n && d[n] && d[base]) e.textContent = d[base] + ': ' + d[n] + ' ' + m[3];
        return;
      }
    });

    document.querySelectorAll('a[href]').forEach(function (e) {
      var h = e.getAttribute('href') || '';
      var mm = h.match(/^([a-z0-9-]+)\.html$/);
      if (!mm) return;
      var nom = PAGES[mm[1]];
      if (!nom || !d[nom]) return;
      var txt = e.textContent.trim();
      if (/^(Suivant|Next)/.test(txt) || /^(Précédent|Previous)/.test(txt)) {
        var flèche = txt.match(/(→|←)$/);
        var sens = /^(Suivant|Next)/.test(txt) ? d['page.suivant'] : d['page.precedent'];
        e.textContent = sens + ': ' + d[nom] + (flèche ? ' ' + flèche[1] : '');
      }
    });
    document.querySelectorAll('h2, .breadcrumb a, .breadcrumb strong, a.btn').forEach(function (e) {
      var k = M[e.textContent.trim()];
      if (k && d[k]) e.textContent = d[k];
    });
  }).catch(function () {});
})();
