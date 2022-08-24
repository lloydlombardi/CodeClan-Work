server <- function(input, output) {
  output$whisky_map <- renderLeaflet(
    whisky_data %>% 
      filter(Region == input$region) %>% 
      leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(
        lat = ~Latitude,
        lng = ~Longitude,
        popup = ~Distillery,
        clusterOptions = markerClusterOptions()
      )
  )
}