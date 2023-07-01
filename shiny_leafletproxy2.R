library(shiny)
library(leaflet)

# Define UI
ui <- fluidPage(
  leafletOutput("map"),
  actionButton("addBand", "Add Band")
)

# Define server logic
server <- function(input, output, session) {
  
  # Keep track of added bands
  bands <- reactiveValues(data = NULL)
  
  # Render map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(data = bands$data, ~Lon, ~Lat, popup = ~Name)
  })
  
  # Add band button click event
  observeEvent(input$addBand, {
    # Clear any previous inputs
    removeModal()
    showModal(
      modalDialog(
        textInput("bandName", "Band Name"),
        textInput("bandGenre", "Band Genre"),
        actionButton("saveBand", "Save Band"),
        footer = NULL
      )
    )
  })
  
  # Save band button click event
  observeEvent(input$saveBand, {
    # Get band details from inputs and map click
    bandName <- input$bandName
    bandGenre <- input$bandGenre
    click <- input$map_click
    
    if (is.null(bands$data)) {
      # Create a new band data frame
      bands$data <- data.frame(Name = bandName, Genre = bandGenre, Lat = click$lat, Lon = click$lng)
    } else {
      # Append band to the existing data frame
      new_band <- data.frame(Name = bandName, Genre = bandGenre, Lat = click$lat, Lon = click$lng)
      bands$data <- rbind(bands$data, new_band)
    }
    
    # Close the modal
    removeModal()
  })
}

# Run the app
shinyApp(ui, server)