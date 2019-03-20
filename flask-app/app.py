from flask import Flask

app = Flask(__name__)


@app.route("/")
@app.route("/<string:name>")
def hello(name="world"):
    return f"<p>Hello, {name}!</p>"
