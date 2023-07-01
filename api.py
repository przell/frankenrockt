from flask import Flask, request
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

@app.route(
    '/bands.csv',
    methods=['GET'],
)
def get_bands_csv():
    with open(CSV_PATH) as src:
        return src.read()

@app.route(
    '/submit',
    methods=['POST'],
)
def ingest_band():
    data = request.json
    csv_line = ','.join((
        data[f]
        for f in FIELDS
    ))
    with open(CSV_PATH, 'a') as dst:
        dst.write(csv_line+'\n')
    with open(CSV_PATH) as src:
        return src.read()

if __name__ == '__main__':
    app.run()
