from flask import Flask, send_from_directory
import os
import socket

app = Flask(__name__)

@app.route("/<path:filename>")
def serve_static(filename):
    root_dir = os.path.dirname(os.getcwd())
    return send_from_directory(os.path.join(root_dir, 'static'), filename)


if __name__ == "__main__":
    app.run(host='0.0.0.0')