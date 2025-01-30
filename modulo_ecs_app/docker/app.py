# Aplicacion Flask en docker

from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "¡Aplicación Flask ejecutándose en AWS ECS con ALB!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
