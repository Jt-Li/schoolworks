#!/usr/bin/python 


import http.server
import socketserver
import sys




PORT = 8080


Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
