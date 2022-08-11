#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(bslib)

olympics_medals <- read_csv("data/olympics_overall_medals.csv")

all_seasons <- unique(olympics_medals$season)
all_teams <- unique(olympics_medals$team)

olympics_medals <- olympics_medals %>% 
  mutate(medal = factor(medal, c("Gold", "Silver", "Bronze")))

# User Interface
ui <- fluidPage(
  
  # theme = bs_theme(bootswatch = 'flatly'),
  # theme = 'path_to/my_stylesheet.css',
  
  titlePanel(tags$h1("Olympic Medals")),
  
  tabsetPanel(
    
    tabPanel("Plot",
             plotOutput('medal_plot')
    ),
    
    tabPanel("Which season?",
             radioButtons(inputId = 'season_input',
                          label = tags$i('Summer or Winter Olympics?'),
                          choices = all_seasons)  
    ),
    
    tabPanel("Which team?",
             selectInput(inputId = 'team_input',
                         label = 'Which team?',
                         choices = all_teams)  
    )
  ),
  
  # HTML: HyperText Markup Language
  tags$a('The Olympics website', href = 'https://www.Olympic.org')
  
)

server <- function(input, output) {
  
  output$medal_plot <- renderPlot({
    olympics_medals %>% 
      filter(team == input$team_input,
             season == input$season_input) %>%
      ggplot(aes(x = medal, 
                 y = count, 
                 fill = medal)) +
      geom_col()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)