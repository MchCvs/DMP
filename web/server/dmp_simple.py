#!/usr/bin/env python3
# Copyright (C) 2026 Thierry CHEVASSUS — GPL-3.0-or-later — voir LICENSE
import os
import re
import subprocess
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
from urllib.parse import urlsplit

DMP_ROOT = Path(__file__).resolve().parents[2]
HTML_ROOT = (DMP_ROOT / 'web' / 'html').resolve()
COLLECTEURS = (DMP_ROOT / 'modules' / 'collecteurs').resolve()
API_NAME = re.compile(r'[a-z0-9_]+')
TYPES = {
    '.html': 'text/html; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
}


class DMPHandler(SimpleHTTPRequestHandler):
    def send_body(self, ctype, body):
        self.send_response(200)
        self.send_header('Content-Type', ctype)
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urlsplit(self.path).path  # ignore ?lang=fr et autres paramètres
        if path.startswith('/api/'):
            self.handle_api(path[len('/api/'):])
        else:
            self.handle_static('/menu.html' if path == '/' else path)

    def handle_api(self, name):
        if not API_NAME.fullmatch(name):
            return self.send_error(400, 'Nom de collecteur invalide')
        script = (COLLECTEURS / f'{name}.sh').resolve()
        if script.parent != COLLECTEURS or not script.is_file():
            return self.send_error(404, 'Collecteur introuvable')
        try:
            result = subprocess.run(['bash', str(script)], capture_output=True,
                                    text=True, timeout=90)
        except subprocess.TimeoutExpired:
            return self.send_error(504, 'Collecteur trop long')
        except OSError:
            return self.send_error(500, 'Erreur interne')
        self.send_body('application/json; charset=utf-8', result.stdout.encode())

    def handle_static(self, path):
        # Fichiers fournis par un autre paquet Debian (liste blanche, pas de chemin libre)
        PAQUETS = {'/vendor/chart.min.js': Path('/usr/share/javascript/chart.js/Chart.min.js')}
        if path in PAQUETS and PAQUETS[path].is_file():
            return self.send_body('application/javascript; charset=utf-8', PAQUETS[path].read_bytes())
        target = (HTML_ROOT / path.lstrip('/')).resolve()
        if not target.is_relative_to(HTML_ROOT) or not target.is_file():
            return self.send_error(404, 'Page introuvable')
        ctype = TYPES.get(target.suffix, 'application/octet-stream')
        self.send_body(ctype, target.read_bytes())


os.chdir(HTML_ROOT)
server = HTTPServer(('127.0.0.1', 8765), DMPHandler)
print('✅ DMP Server: http://127.0.0.1:8765/')
server.serve_forever()
