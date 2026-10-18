#!/usr/bin/env python3
# Copyright (C) 2026 Thierry CHEVASSUS — GPL-3.0-or-later — voir LICENSE
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
from urllib.parse import urlparse, parse_qs
DMP_ROOT = Path(__file__).resolve().parents[2]
import subprocess
import os

class DMPHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        # Routes API
        if self.path.startswith('/api/'):
            u = urlparse(self.path)
            api_key = u.path.split('/')[-1]
            lang = parse_qs(u.query).get('lang', ['fr'])[0]
            if lang not in ('fr', 'en', 'de'):
                lang = 'fr'
            script = f'{DMP_ROOT}/modules/collecteurs/{api_key}.sh'
            
            if Path(script).exists():
                try:
                    result = subprocess.run(['bash', script], capture_output=True, text=True, timeout=90,
                                            env=dict(os.environ, DMP_LANG=lang))
                    self.send_response(200)
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(result.stdout.encode())
                except Exception as e:
                    self.send_error(500, str(e))
            else:
                self.send_error(404, f"Script not found: {api_key}")
            return
        
        # Fichiers statiques
        if self.path == '/':
            self.path = '/menu.html'
        
        # Servir depuis web/html/
        try:
            file_path = (DMP_ROOT / 'web' / 'html') / self.path.lstrip('/')
            
            if file_path.is_file():
                with open(file_path, 'rb') as f:
                    content = f.read()
                
                self.send_response(200)
                if str(file_path).endswith('.html'):
                    self.send_header('Content-Type', 'text/html')
                elif str(file_path).endswith('.js'):
                    self.send_header('Content-Type', 'application/javascript')
                elif str(file_path).endswith('.css'):
                    self.send_header('Content-Type', 'text/css')
                self.end_headers()
                self.wfile.write(content)
            else:
                self.send_error(404, str(file_path))
        except Exception as e:
            self.send_error(500, str(e))

os.chdir(DMP_ROOT / 'web' / 'html')
server = HTTPServer(('127.0.0.1', 8765), DMPHandler)
print('✅ DMP Server: http://127.0.0.1:8765/')
server.serve_forever()
