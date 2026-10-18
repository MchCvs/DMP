// DMP : traduction du cadre commun des pages (FR / EN / DE)
// Copyright (C) 2026 Thierry CHEVASSUS — GPL-3.0-or-later — voir LICENSE
(function () {
  var SUP = ['fr', 'en', 'de'];
  function pick() {
    var p = new URLSearchParams(location.search).get('lang');
    var s = null;
    try { s = localStorage.getItem('dmp_lang'); } catch (e) {}
    var l = p || s || (navigator.language || 'fr').slice(0, 2);
    return SUP.indexOf(l) >= 0 ? l : 'fr';
  }
  var LANG = pick();
  try { localStorage.setItem('dmp_lang', LANG); } catch (e) {}
  window.DMP_LANG = LANG;
  document.documentElement.lang = LANG;

  // Les appels à l'API transmettent la langue au collecteur
  var realFetch = window.fetch;
  window.fetch = function (u, o) {
    if (typeof u === 'string' && u.indexOf('/api/') === 0 && u.indexOf('lang=') < 0) {
      u += (u.indexOf('?') < 0 ? '?' : '&') + 'lang=' + LANG;
    }
    return realFetch.call(this, u, o);
  };

  var DICT = {
    en: {
      'Menu': 'Menu', 'Aide': 'Help', 'Accueil': 'Home',
      'Comprendre': 'Understand', "Ce qu'on voit": 'What we see',
      'Ce que ça veut dire': 'What it means',
      'Infos techniques (pour experts)': 'Technical info (for experts)',
      'Chargement...': 'Loading...',
      'DMP — Maintenance Debian': 'DMP — Debian Maintenance'
    },
    de: {
      'Menu': 'Menü', 'Aide': 'Hilfe', 'Accueil': 'Startseite',
      'Comprendre': 'Verstehen', "Ce qu'on voit": 'Was wir sehen',
      'Ce que ça veut dire': 'Was das bedeutet',
      'Infos techniques (pour experts)': 'Technische Infos (für Experten)',
      'Chargement...': 'Lädt...',
      'DMP — Maintenance Debian': 'DMP — Debian-Wartung'
    }
  };
  var PAT = {
    en: [[/^Section (\S+)$/, 'Section $1'], [/^Suivant : (.+) →$/, 'Next: $1 →']],
    de: [[/^Section (\S+)$/, 'Bereich $1'], [/^Suivant : (.+) →$/, 'Weiter: $1 →']]
  };

  function tr(txt) {
    if (LANG === 'fr') return txt;
    var m = txt.match(/^([^\p{L}\p{N}]*)([\s\S]*?)(\s*)$/u);
    if (!m) return txt;
    var core = m[2], out = (DICT[LANG] || {})[core];
    if (out === undefined) {
      var pats = PAT[LANG] || [];
      for (var i = 0; i < pats.length; i++) {
        if (pats[i][0].test(core)) { out = core.replace(pats[i][0], pats[i][1]); break; }
      }
    }
    return out === undefined ? txt : m[1] + out + m[3];
  }

  function walk(root) {
    var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);
    var x;
    while ((x = w.nextNode())) {
      var p = x.parentNode.nodeName;
      if (p === 'SCRIPT' || p === 'STYLE') continue;
      if (x.nodeValue.trim()) x.nodeValue = tr(x.nodeValue);
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    walk(document.body);
    var nav = document.querySelector('nav') || document.querySelector('header');
    if (!nav) return;
    var box = document.createElement('span');
    box.style.cssText = 'float:right;margin-right:10px';
    SUP.forEach(function (l) {
      var a = document.createElement('a');
      a.href = '#';
      a.textContent = l.toUpperCase();
      a.style.cssText = 'color:white;margin:0 6px;text-decoration:none;' +
        (l === LANG ? 'font-weight:bold;text-decoration:underline;' : '');
      a.onclick = function (e) {
        e.preventDefault();
        try { localStorage.setItem('dmp_lang', l); } catch (x) {}
        location.reload();
      };
      box.appendChild(a);
    });
    nav.appendChild(box);
  });
})();
