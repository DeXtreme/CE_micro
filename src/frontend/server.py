import os
import requests
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    backend_url = os.environ.get("backend")
    return render_template('index.html',backend_url=backend_url)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4000)
