if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,ggpubr,thematic,shinythemes,shiny)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          selectizeInput("games", "Choose up to 5 Games:", unique(games$name), 
                         multiple = TRUE, 
                         selected = "Grand",
                         options = list(maxItems = 3))
          selectInput("input", h3("Choose value"), 
                      choices = list("Genre" = genre,
                                     "Console Company" = cons_comp,
                                     "Console Type" = platform_name,
                                     "Metacritic Score" = metacritic_category,
                                     "Publisher" = publisher,
                                     "Developer" = developer,
                                     "ESRB Rating" = esrb_rating_name), selected = genre),
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
