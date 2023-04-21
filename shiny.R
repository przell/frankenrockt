# shiny app for frankenrockt
#
# missing
# - text mask open upon setting the marker
# - fill the text mask
# - add the created entry to the existing data
# - SAVE THE NEW DATA GLOBALLY VISIBLE FOR EVERY USER

# to do
# - open map with existing data (map and table)
# - button "Band platzieren" (somewhere on the lower right)
# - Click button
# - Sidebar Text input dialogue opens for entering band info
# - Enter Band information
# - Click in Map where the band is from (only show last click)
# - button "Tu es, platzier' mich!"  = Submit
# - This should save the enty to a file or db

# After Submit
# - Reinitialize the whole map with the newly entered band
# - Update the Table
# - Update the Map




# libs -------------------------------------------------------------------------
library(shiny)
library(leaflet)
library(sf)
library(mapview)

# available data ---------------------------------------------------------------
# tst_dat1 = data.frame(name = "Swedish Curtains", 
#                       motto = "Hardrockband from Münchsteinach fighting to hold the rythm", 
#                       genre = "Hard Rock", 
#                       from = 2006, 
#                       to = 2020, 
#                       song = paste0("can't stop: <a href=", "https://www.youtube.com/watch?v=j37Ii20Ddo4",">", "https://www.youtube.com/watch?v=j37Ii20Ddo4", "</a>"), 
#                       x = 10.5968, 
#                       y = 49.6375)
# tst_dat2 = data.frame(name = "Die Verstimmten Klimexperten", 
#                       motto = "Four from the future.", 
#                       genre = "Hard Rock", 
#                       from = 2004, 
#                       to = 2010, 
#                       song = "not online", 
#                       x = 10.62131, 
#                       y = 49.58177)
# bands = rbind(tst_dat1, tst_dat2)

bands = read.csv(file = "shiny_bands.csv")
bands$x = round(x = bands$x, digits = 5)
bands$y = round(x = bands$y, digits = 5)
bands_sf = sf::st_as_sf(x = bands, coords = c("x", "y"), crs = st_crs(4326))
mv = mapview(x = bands_sf, label = bands_sf$name)

modal_add_band <- function(name,
                           motto,
                           genre,
                           from,
                           to,
                           song,
                           x, y) {
  modalDialog(
  textInput(inputId = "name", label = "name",
            placeholder = "Mei geile Band", value = name),
  textInput(inputId = "motto", label = "motto",
            placeholder = "Rock mer a weng, alter?", value = motto), 
  # textInput(inputId = "genre", label = "genre",
  #           placeholder = "Hard Rock", value = genre),
  selectInput(inputId = "genre", label = "genre", 
              choices = c("Hard Rock", "Metal", "Punk", "Indie", "Kein Rock")),
  textInput(inputId = "from", label = "from",
            placeholder = "1984", value = from),
  textInput(inputId = "to", label = "to",
            placeholder = "2023", value = to),
  actionButton("loc", "Ort auf Karte wählen..."),
  textInput(inputId = "x", label = "longitude", value = x),
  textInput(inputId = "y", label = "latitude", value = y),
  textInput(inputId = "song", label = "song",
            placeholder = "copy link here", value = song),
  title = "Band platzieren:",
  footer = tagList(
    actionButton("cancel", "Cancel"),
    actionButton("ok", "Ok")
  )
)
}

# ui ---------------------------------------------------------------------------
ui <- fluidPage(
  # Application title
  titlePanel("frankenrockt"),
  
  # UI Inputs
  sidebarLayout(
    sidebarPanel(
      actionButton("add_band", "Band platzieren")
    ),
    
    # UI Outputs
    mainPanel(
      tabsetPanel(
        tabPanel("Kartierte", leafletOutput(outputId = "map")), 
        tabPanel("Gelistete", dataTableOutput(outputId = "table"))
      ),
      textOutput(outputId = "bands_df")
    )
  )
)

select_location <- FALSE
name <- ""
motto <- ""
genre <- ""
from <- ""
to <- ""
song <- ""

reset_values <- function() {
  select_location <<- FALSE
  name <<- ""
  motto <<- ""
  genre <<- ""
  from <<- ""
  to <<- ""
  song <<- ""
}

# server -----------------------------------------------------------------------
server <- function(input, output, session) {
  
  # plot the map as is
  output$map = renderLeaflet({ mv@map }) # renderLeaflet({leaflet() %>% addTiles() })
  
  # plot the table as is
  output$table = renderDataTable(bands)
  
  observeEvent(input$add_band, {
    showModal(modal_add_band(name = name,
                             motto = motto,
                             genre = genre,
                             from = from,
                             to = to,
                             song = song,
                             x = click_location$location$lng,
                             y = click_location$location$lat))
  })
  
  observeEvent(input$loc, {
    showNotification("Ort auf Karte wählen...")
    select_location <<- TRUE
    name <<- input$name
    motto <<- input$motto
    genre <<- input$genre
    from <<- input$from
    to <<- input$to
    song <<- input$song
    removeModal()
  })
  
  observeEvent(input$ok, {
    showNotification("Band platziert!")
    removeModal()
    reset_values()
  })
  
  observeEvent(input$cancel, {
    removeModal()
    reset_values()
  })
  
  # observe({
  #   click = input$map_click
  #   leafletProxy('map') %>% addCircleMarkers(lng = click$lng, lat = click$lat)
  # }) %>%
  #   bindEvent(input$map_click)
  
  click_location = reactiveValues(location = NULL)

  observeEvent(input$map_click, {
    click_location$location = input$map_click
    if (select_location) {
      select_location <<- FALSE
      showModal(modal_add_band(name = name,
                               motto = motto,
                               genre = genre,
                               from = from,
                               to = to,
                               song = song,
                               x = click_location$location$lng,
                               y = click_location$location$lat))
    }
    })
  
  #When "Save" is pressed should append data to df and export
  observeEvent(input$ok, {
    band_new <- data.frame(name = input$name, 
                           motto = input$motto, 
                           genre = input$genre, 
                           from = input$from, 
                           to = input$to, 
                           song = input$song, 
                           x = round(click_location$location$lng, 5),
                           y = round(click_location$location$lat, 5))
    bands <- rbind(bands, band_new)
    ReactiveDf(bands) # set reactiveVal's value.
    write.csv(x = bands, file = "shiny_bands.csv", row.names = FALSE) #This export works but the date is saved incorrectly as "17729" not sure why
  })
  
  # Create a reactive dataset to allow for easy updating
  ReactiveDf <- reactiveVal(bands)
  
  # Create the table of all the data
  output$table <- renderDataTable({
    ReactiveDf()
  })
  
  
  
}


# run -----------------------------------------------------------------------
shinyApp(ui, server)

# https://stackoverflow.com/questions/51379806/updating-a-data-frame-in-real-time-in-rshiny

# Another version that saves the lat lon and prints it, allows for multiple clicks ----
# https://stackoverflow.com/questions/74393501/leaflet-in-shiny-save-click-coordinates

# action buttons
# https://shiny.rstudio.com/articles/action-buttons.html

# Make second button appear after first
# https://stackoverflow.com/questions/55503965/r-shiny-make-second-action-button-2-appear-after-action-button-1-is-clicked
