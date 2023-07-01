# frankenrockt
Music to the map. Map of rockbands of today, yesterday and tomorrow.

## Check it out now

static example: [frankenrockt](https://przell.github.io/frankenrockt/)

## Mission
Tragt euch ein wenn ihr Rocker seid. Egal ob von heute, gestern oder morgen. Das ist eine Landrockkarte von Musikern für Musiker. Auch ausserhalb Frankens könnt Ihr euch eintragen, aber der Fokus ist und bleibt Franken - ["Deutschlands beste Gitarrenmusik kommt nun mal aus der Provinz"](https://www.br.de/radio/bayern2/sendungen/podcasts/fraenkische-garagenbands-aus-den-spaeten-achtzigern-102.html "BR2 Nachtmix - Fränkische Garagenrockbands auf den späten 80ern")

Add your band if you're a rocker. Doesn't matter if your band is from today, yesterday or tomorrow.
This is rock map from musicians for musicians. You can also add bands outside of Franconia.
But the focus has been, is and will be Franconia - ["Deutschlands beste Gitarrenmusik kommt nun mal aus der Provinz"](https://www.br.de/radio/bayern2/sendungen/podcasts/fraenkische-garagenbands-aus-den-spaeten-achtzigern-102.html "BR2 Nachtmix - Fränkische Garagenrockbands auf den späten 80ern")

## Development Plan
### Map
- A marker represents a band. If there are too many use clustered markers.
- Upon click on a marker the pop up opens with the description of the band.
- Every band has one song that can be played directly. Or a link to a song.

### Add a new band
- Click "Add Band"
- A Form opens for entering the info on the band.
  - Name
  - Motto
  - Genre
  - Active From
  - Active To
  - Song
- Click on the map to add the coordinates.
- Click "Ok"
- The band is saved to the database and directly visible on the map and in the table.

### Build
- Host the shiny app via github actions

