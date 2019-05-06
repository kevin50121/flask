from flask import Flask

app = Flask(__name__)

@app.route('/')
def helloIndex():
    return 'Hello World 5 !'

app.run(host='0.0.0.0', port=5000)