# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(plotly)


# wrangling ---------------------------------------------------------------

students <- read_csv("data/students_big.csv")

plot_choice <- c("Bar", "Horizontal Bar", "Stacked Bar")

p1 <- students %>% 
  ggplot(aes(x = handed,
             fill = gender)) +
  geom_bar(position = "dodge")

p2 <- students %>% 
  ggplot(aes(x = handed,
             fill = gender)) +
  geom_bar(position = "dodge") +
  coord_flip()

p3 <- students %>% 
  ggplot(aes(x = handed,
             fill = gender)) +
  geom_bar(position = "stack")

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  fluidRow(
    
    column(12,
           radioButtons(inputId = "plot_type",
                        label = "Plot Type",
                        choices = plot_choice)
    )
  ),
  
  fluidRow(
    
    column(12,
           plotOutput("a_plot")
    )
  )
  
)

# server ------------------------------------------------------------------

server <- function(input, output) {
  
  output$a_plot <- renderPlot({
    
    if (input$plot_type == "Bar") {print(p1)}
    if (input$plot_type == "Horizontal Bar") {print(p2)}
    if (input$plot_type == "Stacked Bar") {print(p3)}
  })
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)