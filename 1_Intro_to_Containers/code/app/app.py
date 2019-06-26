from flask import Flask, url_for, send_from_directory
import os

app = Flask(__name__)


@app.route('/')
@app.route('/index.html')
def index():
    return send_from_directory('static','index.html')


with app.test_request_context():
   url_for('static', filename='index.html')
   url_for('static', filename='cisco.png')
   url_for('static', filename='heart.png')
   url_for('static', filename='k8s.png')


if __name__ == "__main__":
    app.run(host='0.0.0.0')