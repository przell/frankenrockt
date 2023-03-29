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
bands = rbind(tst_dat1, tst_dat2)
bands_sf = sf::st_as_sf(x = bands, coords = c("x", "y"), crs = st_crs(4326))
mv = mapview(x = bands_sf, label = bands_sf$name)

# ui ---------------------------------------------------------------------------
ui <- fluidPage(
  # Application title
  titlePanel("frankenrockt"),
  
  # UI Inputs
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "name", label = "name", placeholder = "Mei geile Band"),
      textInput(inputId = "motto", label = "motto", placeholder = "Rock mer a weng, alter?"), 
      textInput(inputId = "genre", label = "genre", placeholder = "Hard Rock"),
      textInput(inputId = "from", label = "from", placeholder = "1984"),
      textInput(inputId = "to", label = "to", placeholder = "2023"),
      textInput(inputId = "song", label = "song", placeholder = "copy link here"),
      actionButton("band_describe", "Band platzieren!")
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


# server -----------------------------------------------------------------------
server <- function(input, output, session) {
  
  # plot the map as is
  output$map = renderLeaflet({ mv@map }) # renderLeaflet({leaflet() %>% addTiles() })
  
  # plot the table as is
  output$table = renderDataTable(bands)
  
  # observe({
  #   click = input$map_click
  #   leafletProxy('map') %>% addCircleMarkers(lng = click$lng, lat = click$lat)
  # }) %>%
  #   bindEvent(input$map_click)
  
  click_location = reactiveValues(location = NULL)

  observeEvent(input$map_click, {
    click_location$location = input$map_click
    leafletProxy('map') %>% addCircleMarkers(lng = click_location$location$lng, 
                                             lat = click_location$location$lat)
    })
  
  #When "Save" is pressed should append data to df and export
  observeEvent(input$band_describe, {
    band_new <- data.frame(name = input$name, 
                           motto = input$motto, 
                           genre = input$genre, 
                           from = input$from, 
                           to = input$to, 
                           song = input$song, 
                           x = click_location$location$lng,
                           y = click_location$location$lat)
    bands <- rbind(bands, band_new)
    ReactiveDf(bands) # set reactiveVal's value.
    write.csv(bands, "shiny_bands.csv") #This export works but the date is saved incorrectly as "17729" not sure why
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
