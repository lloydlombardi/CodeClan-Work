
# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(plotly)


# wrangling ---------------------------------------------------------------

students <- read_csv("data/students_big.csv")

ages <- students %>% 
  distinct(ageyears) %>%
  arrange(ageyears) %>% 
  pull()



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  fluidRow(
    
    column(6,
           radioButtons(inputId = "ages_input",
                        label = "Age",
                        choices = ages,
                        inline = TRUE)
    )
  ),
  
  br(),
  
  fluidRow(
    
    column(6,
           plotOutput("height_plot")
    ),
    
    column(6,
           plotOutput("arm_span_plot")
    )
  )
)



# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data <- reactive({
    students %>% 
      filter(ageyears == input$ages_input)
  })
  
  output$height_plot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = height)) +
      geom_histogram(bins = 20)
  })
  
  output$arm_span_plot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = arm_span)) +
      geom_histogram(bins = 20)
  })
  
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
