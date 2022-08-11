# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(plotly)


# wrangling ---------------------------------------------------------------

students <- read_csv("data/students_big.csv")

all_genders <- students %>% 
  distinct(gender) %>% 
  pull()

all_regions <- students %>% 
  distinct(region) %>% 
  pull()


# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      selectInput(inputId = "gender_choice",
                  label = "Gender",
                  choices = all_genders),
      
      selectInput(inputId = "region_choice",
                  label = "Region",
                  choices = all_regions),
      
      actionButton(inputId = "update",
                   label = "Generate Plots and Table")
    ),
    
    mainPanel = mainPanel(
      tabsetPanel(
        
        tabPanel("Plots",
                 fluidRow(
                   
                   column(4,
                          plotOutput("importance_internet")
                   ),
                   
                   column(4,
                          plotOutput("importance_pollution"))
                 )
        ),
        
        tabPanel("Data", 
                 DT::dataTableOutput("table_output")
        )
      )
    )
  )
)

# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data <- eventReactive(input$update, {
    students %>% 
      filter(gender == input$gender_choice,
             region == input$region_choice)
  })
  
  output$importance_internet <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = importance_internet_access)) +
      geom_histogram()
  })
  
  output$importance_pollution <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = importance_reducing_pollution)) +
      geom_histogram()
  })
  
  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
}

# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
