library(shiny)
library(leaflet)

ui <- fluidPage(
  leafletOutput("myMap"),
  tableOutput("pointTable")
)

server <- function(input, output) {
  # The initial set of existing points on the map
  existingPoints <- data.frame(
    lng = c(10.7931, 10.8125, 11.0119),
    lat = c(49.6000, 49.6000, 49.6000)
  )
  
  # Reactive values to store clicked points
  points <- reactiveValues(data = existingPoints)
  
  observeEvent(input$myMap_click, {
    click <- input$myMap_click
    
    # Add clicked point to the data frame
    newPoint <- data.frame(lng = click$lng, lat = click$lat)
    points$data <- rbind(points$data, newPoint)
  })
  
  output$myMap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = 10.7931, lat = 49.6000, zoom = 8) %>%
      addMarkers(
        data = points$data,
        lng = ~lng, lat = ~lat,
        label = "Point"
      )
  })
  
  output$pointTable <- renderTable({
    points$data
  })
}

shinyApp(ui, server)