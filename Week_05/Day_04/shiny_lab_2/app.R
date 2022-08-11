# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(plotly)


# wrangling ---------------------------------------------------------------

students <- read_csv("data/students_big.csv")



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  titlePanel(tags$h1("Reaction Time vs. Memory Game")),
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      radioButtons(inputId = "colour_choice",
                   label = "Colour of points",
                   choices = c(Blue = "#3891A6", Yellow = "#FDE74C", Red = "#E3655B")
                   ),
      
      sliderInput(inputId = "transparency",
                  label = "Transparency of points",
                  min = 0,
                  max = 1,
                  step = 0.1,
                  value = 0.2),
      
      selectInput(inputId = "shape_choice",
                  label = "Shape of Points",
                  choices = c("Square" = "15", "Circle" = "16", "Triangle" = "17")),
      
      textInput(inputId = "title_choice",
                  label = "Title of Graph",
                  value = "Enter text..." )
      
    ),
    
    mainPanel = mainPanel(
      
      br(),
      
      plotOutput("reaction_plot")
    )
  )
)



# server ------------------------------------------------------------------

server <- function(input, output) {
  
  output$reaction_plot <- renderPlot({
    students %>% 
      ggplot(aes(x = reaction_time,
                 y = score_in_memory_game)) +
      geom_point(shape = as.integer(input$shape_choice),
                 colour = input$colour_choice, alpha = input$transparency, show.legend = FALSE) +
      ggtitle(label = input$title_choice)
  })
}



# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)