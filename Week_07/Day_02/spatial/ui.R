ui <- fluidPage(
  # input
  selectInput(
    "region",
    "Which region?",
    choices = regions
  ),
  # output
  leafletOutput("whisky_map")
)
