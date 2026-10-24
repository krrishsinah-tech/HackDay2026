import http.server
import socketserver
import urllib.parse
import subprocess
import os

PORT = 8080
DIRECTORY = '/Users/jeetganguly/Documents/Notes/To Do/umeed/web'

class UmeedHTTPHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        if parsed.path == '/api/speak':
            query = urllib.parse.parse_qs(parsed.query)
            text = query.get('text', [''])[0]
            voice = query.get('voice', ['Lekha'])[0]
            if text:
                try:
                    subprocess.Popen(['say', '-v', voice, text])
                except Exception as e:
                    print('Error in say command:', e)
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(b'{"status":"ok"}')
            return
        super().do_GET()

if __name__ == '__main__':
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(('', PORT), UmeedHTTPHandler) as httpd:
        print(f'Umeed Server serving at http://localhost:{PORT}', flush=True)
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            pass
