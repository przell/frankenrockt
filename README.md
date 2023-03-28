# frankenrockt
Musik auf die Karte. Karte für fränkische Rockbands von heute, gestern und morgen.

## Mission
Tragt euch ein wenn ihr Rocker seid. Egal ob von heute, gestern oder morgen. Das ist eine Landrockkarte von Musikern für Musiker. Auch ausserhalb Frankens könnt Ihr euch eintragen, aber der Fokus ist und bleibt Franken - ["Deutschlands beste Gitarrenmusik kommt nun mal aus der Provinz"](https://www.br.de/radio/bayern2/sendungen/podcasts/fraenkische-garagenbands-aus-den-spaeten-achtzigern-102.html "BR2 Nachtmix - Fränkische Garagenrockbands auf den späten 80ern")

## Development Plan
### Karte
- Die Karte sieht aus wie die [ADO Webplatform](https://ado.eurac.edu/)
- Es gibt Marker und geclusterte Marker wenn es zu viele sind die zeigen wo die Band herkommt.
- Bei Click öffnet sich die Bandbeschreibung mit den Feldern wie unten beschrieben.
- Jede Band hat einen Song der direkt abgespielt werden kann.

### Maske
- Die Maske zum Eintragen neuer Bands soll für jeden direkt im Browser offen sein.
- Nach dem Wählen von neuen Eintrag erstellen soll der User auf die Karte clicken dort wird der Marker erscheinen. 
- Die Folgende Maske geht auf
  - Name
  - Beschreibung (20 Wörter)
  - Location
  - Jahre Aktiv
  - Genre
  - 1 Song
- Click "Ok"

### Build
- A) Ein merge request wird automatisch zu diesem Repo gemacht. Der wird dann von mir akzeptiert.
- B) Die Daten kommen in eine PostGIS Datenbank, JSON files, sf objekt.
- C) Alles läuft über eine Shiny App
