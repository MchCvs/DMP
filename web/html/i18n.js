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
      "C1 Mises à jour": "C1 Updates",
      "C4 Infos techniques": "C4 Technical info",
      "B1 Depuis combien de temps ça tourne": "B1 How long it has been running",
      "B2 Utilisation Processeur maintenant (%)": "B2 Processor usage now (%)",
      "B3 Utilisation Mémoire maintenant (%)": "B3 Memory usage now (%)",
      "B4 Utilisation Disque maintenant (%)": "B4 Disk usage now (%)",
      "B5 Réseau maintenant": "B5 Network now",
      "B6 Services": "B6 Services",
      "B7 Programmes en cours": "B7 Running programs",
      "B8 Démarrage": "B8 Startup",
      "B9 Sécurité": "B9 Security",
      "Infos techniques": "Technical info",
      "A1 — Le processeur de votre ordinateur": "A1 — The processor of your computer",
      "A1 Processeur": "A1 Processor",
      "A2 Mémoire vive": "A2 Memory (RAM)",
      "A3 Disques": "A3 Disks",
      "A4 Réseau": "A4 Network",
      "A5 Carte graphique": "A5 Graphics card",
      "A6 Carte mère": "A6 Motherboard",
      "A7 Système Debian": "A7 Debian system",
      "A8 Ports USB": "A8 USB ports",
      "A9 Alimentation électrique": "A9 Power supply",
      'DMP — Maintenance Debian': 'DMP — Debian Maintenance'
    },
    de: {
      'Menu': 'Menü', 'Aide': 'Hilfe', 'Accueil': 'Startseite',
      'Comprendre': 'Verstehen', "Ce qu'on voit": 'Was wir sehen',
      'Ce que ça veut dire': 'Was das bedeutet',
      'Infos techniques (pour experts)': 'Technische Infos (für Experten)',
      'Chargement...': 'Lädt...',
      "C1 Mises à jour": "C1 Aktualisierungen",
      "C4 Infos techniques": "C4 Technische Infos",
      "B1 Depuis combien de temps ça tourne": "B1 Wie lange er schon läuft",
      "B2 Utilisation Processeur maintenant (%)": "B2 Prozessorauslastung jetzt (%)",
      "B3 Utilisation Mémoire maintenant (%)": "B3 Arbeitsspeicherauslastung jetzt (%)",
      "B4 Utilisation Disque maintenant (%)": "B4 Datenträgerauslastung jetzt (%)",
      "B5 Réseau maintenant": "B5 Netzwerk jetzt",
      "B6 Services": "B6 Dienste",
      "B7 Programmes en cours": "B7 Laufende Programme",
      "B8 Démarrage": "B8 Systemstart",
      "B9 Sécurité": "B9 Sicherheit",
      "Infos techniques": "Technische Infos",
      "A1 — Le processeur de votre ordinateur": "A1 — Der Prozessor Ihres Computers",
      "A1 Processeur": "A1 Prozessor",
      "A2 Mémoire vive": "A2 Arbeitsspeicher",
      "A3 Disques": "A3 Datenträger",
      "A4 Réseau": "A4 Netzwerk",
      "A5 Carte graphique": "A5 Grafikkarte",
      "A6 Carte mère": "A6 Hauptplatine",
      "A7 Système Debian": "A7 Debian-System",
      "A8 Ports USB": "A8 USB-Anschlüsse",
      "A9 Alimentation électrique": "A9 Stromversorgung",
      'DMP — Maintenance Debian': 'DMP — Debian-Wartung'
    }
  };
  var PAT = {
    en: [[/^Section (\S+)$/, 'Section $1'], [/^Suivant : (.+) →$/, 'Next: $1 →'], [/^Précédent : (.+)$/, 'Previous: $1']],
    de: [[/^Section (\S+)$/, 'Bereich $1'], [/^Suivant : (.+) →$/, 'Weiter: $1 →'], [/^Précédent : (.+)$/, 'Zurück: $1']]
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
