from elasticapm.contrib.flask import ElasticAPM
from elasticapm.handlers.logging import LoggingHandler
from flask import Flask
from apscheduler.schedulers.background import BackgroundScheduler
import atexit
import logging
import requests

app = Flask(__name__)

app.config['ELASTIC_APM'] = {
    'SERVER_URL': 'http://192.168.1.104:8200',
    'DEBUG': True
}

apm = ElasticAPM(app, service_name="flask-app", logging=logging.DEBUG)

@app.route("/hi")
def print_hi():
    return "Hi"

def call_hi():
    return requests.get(url = "http://127.0.0.1:80/hi")

scheduler = BackgroundScheduler()
scheduler.add_job(func=call_hi, trigger="interval", seconds=10)
scheduler.start()
atexit.register(lambda: scheduler.shutdown())

if __name__ == '__main__':
    handler = LoggingHandler(client=apm.client)
    handler.setLevel(logging.WARN)
    app.logger.addHandler(handler)
    app.logger.error('Hello Elastic APM ;) This is an Error!')

    app.run(debug=True, host='0.0.0.0', port=80, use_reloader=False)



