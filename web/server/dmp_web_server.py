#!/usr/bin/env python3
# Copyright Thierry CHEVASSUS — PolyForm Noncommercial 1.0.0 — voir LICENSE
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import subprocess
import json
import os

DMP_ROOT = Path.home() / "DMP-FINAL"
WEB_ROOT = DMP_ROOT / "web" / "html"
COLLECTORS = DMP_ROOT / "modules" / "collecteurs"

# Routes API
ROUTES = {
    '/api/a1': f'{COLLECTORS}/a1.sh',
    '/api/a2': f'{COLLECTORS}/a2.sh',
    '/api/a3': f'{COLLECTORS}/a3.sh',
    '/api/a4': f'{COLLECTORS}/a4.sh',
    '/api/a5': f'{COLLECTORS}/a5.sh',
    '/api/a6': f'{COLLECTORS}/a6.sh',
    '/api/a7': f'{COLLECTORS}/a7.sh',
    '/api/a8': f'{COLLECTORS}/a8.sh',
    '/api/a9': f'{COLLECTORS}/a9.sh',
    '/api/b1': f'{COLLECTORS}/b1.sh',
    '/api/b2': f'{COLLECTORS}/b2.sh',
    '/api/b3': f'{COLLECTORS}/b3.sh',
    '/api/b4': f'{COLLECTORS}/b4.sh',
    '/api/b5': f'{COLLECTORS}/b5.sh',
    '/api/b6': f'{COLLECTORS}/b6.sh',
    '/api/b7': f'{COLLECTORS}/b7.sh',
    '/api/b8': f'{COLLECTORS}/b8.sh',
    '/api/b9': f'{COLLECTORS}/b9.sh',
    '/api/c1': f'{COLLECTORS}/c1.sh',
    '/api/c2': f'{COLLECTORS}/c2.sh',
    '/api/c3': f'{COLLECTORS}/c3.sh',
    '/api/c4': f'{COLLECTORS}/c4.sh',
    '/api/d1': f'{COLLECTORS}/d1.sh',
    '/api/d2': f'{COLLECTORS}/d2.sh',
    '/api/d3': f'{COLLECTORS}/d3.sh',
    '/api/e1': f'{COLLECTORS}/e1.sh',
    '/api/e2': f'{COLLECTORS}/e2.sh',
    '/api/e3_1': f'{COLLECTORS}/e3-preparer.sh',
    '/api/e3_2': f'{COLLECTORS}/e3-generer.sh',
    '/api/e3_3': f'{COLLECTORS}/e3-consulter.sh',
    '/api/e4_1': f'{COLLECTORS}/e4-preparer.sh',
    '/api/e4_2': f'{COLLECTORS}/e4-verifier.sh',
    '/api/e4_3': f'{COLLECTORS}/e4-usable.sh',
    '/api/f1_1': f'{COLLECTORS}/f1-control.sh',
    '/api/f1_2': f'{COLLECTORS}/f1-results.sh',
    '/api/f1_3': f'{COLLECTORS}/f1-anomalies.sh',
    '/api/f2_1': f'{COLLECTORS}/f2-list.sh',
    '/api/f2_2': f'{COLLECTORS}/f2-add.sh',
    '/api/f2_3': f'{COLLECTORS}/f2-remove.sh',
}

class DMPHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path in ROUTES:
            try:
                script = ROUTES[self.path]
                result = subprocess.run(['bash', str(script)], capture_output=True, text=True, timeout=10)
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.end_headers()
                self.wfile.write(result.stdout.encode())
            except Exception as e:
                self.send_error(500, str(e))
        else:
            self.path = str(WEB_ROOT / self.path.lstrip('/'))
            if self.path.endswith('/'):
                self.path += 'menu.html'
            super().do_GET()

    def translate_path(self, path):
        return str(WEB_ROOT / path.lstrip('/'))

if __name__ == '__main__':
    server = HTTPServer(('127.0.0.1', 8765), DMPHandler)
    print('✅ DMP Server: http://127.0.0.1:8765/')
    server.serve_forever()
