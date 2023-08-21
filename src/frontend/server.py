import requests
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    saying = requests.get("http://backend:5000/").json()['saying']
    return render_template('index.html',saying=saying)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=4000)
