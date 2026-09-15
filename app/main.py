from flask import Flask, jsonify
import socket
import datetime

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(
        message="Hello from the Fintility practical-test microservice!",
        hostname=socket.gethostname(),
        time=datetime.datetime.utcnow().isoformat() + "Z",
    )


@app.route("/health")
def health():
    return jsonify(status="ok"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
