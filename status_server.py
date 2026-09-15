from flask import Flask
app = Flask(__name__)

@app.route('/status/<int:code>')
def status(code):
    return '', code

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
