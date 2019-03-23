from flask import Flask
from prometheus_client import start_http_server, Histogram, Gauge, Counter, Summary

app = Flask(__name__)
start_http_server(8000)

@app.route("/")
@app.route("/<string:name>")
def hello(name="world"):
    return f"<p>Hello, {name}!</p>"
