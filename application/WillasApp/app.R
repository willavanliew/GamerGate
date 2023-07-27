if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,rio,ggpubr,thematic,shinythemes,shiny)
games <- import("application/Final_dev_pub.csv")
dev_names <- import("application/developer_titles.csv")
pub_names <- import("application/publisher_titles.csv")
platform_names <- games %>% select(c(91:136)) %>% names()
genres_names <- games %>% select(c(140:145)) %>% names() 

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          selectInput("genre", h3("Choose a genre"), 
                      choices = genres_names,
                      selected = "All"),
          selectInput("console", h3("Choose a Console Type"),
                      choices = platform_names,
                      select = "All"),
          selectInput("publisher", h3("Choose a Publisher"),
                      choices = list(pub_names$Name), # selection -> filter on input$publisher, select column 
                      select = "All"),
          selectInput("developer", h3("Choose a Developer"),
                      choices = list(dev_names$Name),
                      select = "All"),
          selectInput("esrb", h3("Choose a ESRB Rating"),
                      choices = list(unique(games$esrb_rating_name)),
                      select = "All")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

games_reactive <- reactive(
  # Make it so it only selects what we want to select 
  if (input$genre != "All") {
    filters <- append(filters, input$genre)
  }
  if (input$console != "All"){
    filters <- append(filters, input$console)
  }
  if (input$publisher != "All"){
    filters <- append(filters, input$publisher)
  }
  if (input$developer != "All"){
    filters <- append(filters, input$developer)
  }
  if (input$esrb != "All"){
    filters <- append(filters, input$esrb)
  }
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  games %>%
    

  output$description <- renderText({
    games_reactive()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
