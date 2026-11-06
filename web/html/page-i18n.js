(function () {
  var L = localStorage.getItem('dmp_lang') || 'fr';
  if (L === 'fr') return;
  fetch('/i18n/' + L + '.json').then(function (r) { return r.json(); }).then(function (d) {
    var M = {
      'Accueil': 'page.accueil', 'Comprendre': 'page.comprendre', "Ce qu'on voit": 'page.voit',
      'Ce que ça veut dire': 'page.veut', 'Précédent': 'page.precedent', 'Suivant': 'page.suivant',
      'Retour': 'page.retour', 'Infos techniques (pour experts)': 'page.infos'
    };
    document.querySelectorAll('h2, .breadcrumb a, .breadcrumb strong, a.btn').forEach(function (e) {
      var k = M[e.textContent.trim()];
      if (k && d[k]) e.textContent = d[k];
    });
  }).catch(function () {});
})();
