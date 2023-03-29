# shiny app for frankenrockt
#
# missing
# - text mask open upon setting the marker
# - fill the text mask
# - add the created entry to the existing data
# - SAVE THE NEW DATA GLOBALLY VISIBLE FOR EVERY USER

# libs -------------------------------------------------------------------------
library(shiny)
library(leaflet)
library(sf)

# available data ---------------------------------------------------------------
tst_dat1 = data.frame(name = "Swedish Curtains", 
                      motto = "Hardrockband from Münchsteinach fighting to hold the rythm", 
                      genre = "Hard Rock", 
                      from = 2006, 
                      to = 2020, 
                      song = paste0("can't stop: <a href=", "https://www.youtube.com/watch?v=j37Ii20Ddo4",">", "https://www.youtube.com/watch?v=j37Ii20Ddo4", "</a>"), 
                      x = 10.59689555556497, 
                      y = 49.63753461701194)
tst_dat2 = data.frame(name = "Die Verstimmten Klimexperten", 
                      motto = "Four from the future.", 
                      genre = "Hard Rock", 
                      from = 2004, 
                      to = 2010, 
                      song = "not online", 
                      x = 10.621313357566068, 
                      y = 49.58177091487892)
tst_dat = rbind(tst_dat1, tst_dat2)
frankenrockt = sf::st_as_sf(x = tst_dat, coords = c("x", "y"), crs = st_crs(4326))
mv = mapview(x = frankenrockt, label = frankenrockt$name)

# ui ---------------------------------------------------------------------------
ui <- fluidPage(
  leafletOutput('map')
)


# server -----------------------------------------------------------------------
server <- function(input, output, session) {
  output$map <- renderLeaflet({leaflet()%>%addTiles()})
  
  observe({
    click = input$map_click
    leafletProxy('map')%>%addMarkers(lng = click$lng, lat = click$lat)
  }) %>%
    bindEvent(input$map_click)
}


# deploy -----------------------------------------------------------------------
shinyApp(ui, server)
