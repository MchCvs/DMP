#!/usr/bin/env python3
from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import subprocess
import os

class DMPHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        # Routes API
        if self.path.startswith('/api/'):
            api_key = self.path.split('/')[-1]
            script = f'/home/thierry/DMP-FINAL/modules/collecteurs/{api_key}.sh'
            
            if Path(script).exists():
                try:
                    result = subprocess.run(['bash', script], capture_output=True, text=True, timeout=5)
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
        
        # Servir depuis /home/thierry/DMP-FINAL/web/html/
        try:
            file_path = Path('/home/thierry/DMP-FINAL/web/html') / self.path.lstrip('/')
            
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

os.chdir('/home/thierry/DMP-FINAL/web/html')
server = HTTPServer(('127.0.0.1', 8765), DMPHandler)
print('✅ DMP Server: http://127.0.0.1:8765/')
server.serve_forever()
