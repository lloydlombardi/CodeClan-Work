
library(shiny)
library(tidyverse)


# read in and prep data ---------------------------------------------------

students <- read_csv("data/students_big.csv")

handed_choices <- students %>% 
  distinct(handed) %>% 
  pull()

region_choices <- students %>% 
  distinct(region) %>% 
  pull()

gender_choices <- students %>% 
  distinct(gender) %>% 
  pull()

# radio button for handedness
# table to display the data, filtered by handedness
# add in two plots to the UI, underneath the buttons, above the table
# add in code to the server to render plots

# ui ----------------------------------------------------------------------



ui <- fluidPage(
  
  fluidRow(
    
    column(3,
           radioButtons(inputId = "handed_input",
                        label = "Handedness",
                        choices = handed_choices,
                        inline = TRUE)
    ),
    
    column(3,
           selectInput(inputId = "region_select",
                       label = "Region",
                       choices = region_choices)
    ),
    
    column(3,
           selectInput(inputId = "gender_select",
                       label = "Gender",
                       choices = gender_choices)
    ),
    
    column(3,
           radioButtons(inputId = "colour_input",
                        label = "Plot Colour",
                        choices = c("Pink" = "deeppink", "Blue" = "deepskyblue"),
                        inline = TRUE)
    )
    
  ),
  
  br(),
  
  # ADD IN ACTION BUTTON
  actionButton(inputId = "update",
               label = "Update dashboard"),
  
  br(),
  
  fluidRow(
    column(6,
           plotOutput("travel_barplot")
    ),
    
    column(6,
           plotOutput("spoken_barplot")
    )
  ),
  
  br(),
  
  DT::dataTableOutput("table_output")
  
)



# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data <- eventReactive(input$update, {
    students %>% 
      filter(handed == input$handed_input,
             region == input$region_select,
             gender == input$gender_select)
  }) 
    
    
  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
  
  output$travel_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = travel_to_school)) +
      geom_bar(fill = input$colour_input) +
      labs(x = "Mode of Transport",
           y = "Number of Students",
           title = "How Students Travel to School")
  })
  
  output$spoken_barplot <- renderPlot({
    filtered_data() %>% 
      ggplot(aes(x = languages_spoken))+
      geom_bar(fill = input$colour_input) +
      labs(x = "Number of Languages Spoken",
           y = "Number of Students",
           title = "How Many Languages Students Speak")
  })
}


# run app -----------------------------------------------------------------

shinyApp(ui = ui,
         server = server)
