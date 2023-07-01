from flask import Flask, request, make_response
from pathlib import Path


CSV_PATH = Path(__file__).parent / 'shiny_bands.csv'
FIELDS = (
    'name',
    'motto',
    'genre',
    'from',
    'to',
    'song',
    'x',
    'y',
)

app = Flask(__name__)

def _make_csv_response():
    with open(CSV_PATH) as src:
        resp = src.read()
    resp = make_response(resp)
    resp.mimetype = 'text/plain'
    return resp

@app.route(
    '/bands.csv',
    methods=['GET'],
)
def get_bands_csv():
    return _make_csv_response()

@app.route(
    '/submit',
    methods=['POST'],
)
def ingest_band():
    data = request.json
    csv_line = ','.join((
        str(data[f])
        for f in FIELDS
    ))
    with open(CSV_PATH, 'a') as dst:
        dst.write(csv_line+'\n')
    return _make_csv_response()

if __name__ == '__main__':
    app.run()
