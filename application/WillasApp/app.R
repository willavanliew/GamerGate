if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,rio,ggpubr,thematic,shinythemes,shiny)
games <- import("application/Final_dev_pub.csv")
dev_names <- import("application/developer_titles.csv")
pub_names <- import("application/publisher_titles.csv")
platform_names <- games %>% select(c(91:136)) %>% names()
genres_names <- games %>% select(c(140:145)) %>% names() 

# get games_gt from csv
games_gt <- read_csv("gt.csv")

# Get the index of columns starting with "dev_"
dev_index <- 6:40
# Get the index of columns starting with "pub_"
pub_index <- 41:85
# index of platforms
platform_index <- 86:131
# index of gaming mode
mode_index <- 132:134
# index of genre
genre_index <- 135:140

# write to csv
write_csv(games_gt, "gt.csv")

# create initial GT table object
games_table <- games_gt %>%
  # drop the unnecessary columns
  select(-(6:140)) %>%
  # arrange always by metacritic rating first
  arrange(desc(metacritic)) %>% 
  # create the base gt table
  gt() %>% 
  # add title and subtitle
  tab_header(
    title = md("**GamerGate 2023 Games**"),
    subtitle = "Explore the data used to train the algorithm"
  ) %>% 
  # change date format
  fmt_date(
    columns = released,
    date_style = "m_day_year"
  ) %>% 
  # color metacritic column based on values
  data_color(
    columns = metacritic,
    fn = scales::col_bin(
      palette = "PuBu",
      domain = range(games_gt$metacritic, na.rm=TRUE),
      bins = c(0, 25, 50, 70, 80, 90, 100)
    ),
    alpha = 0.9
  ) %>% 
  # add official column names
  cols_label(
    name = md("**Game Title**"),
    metacritic = md("**Metacritic Rating**"),
    released = "Release Date",
    esrb_rating_name = "ESRB Rating",
    background_image = "Background Image") %>% 
  # Add images to GT table
  text_transform(
    # Apply a function to a column to return the game logo
    locations = cells_body(background_image),
    fn = function(x) {
      # Return an image of set dimensions
      web_image(
        url = x,
        height = 60
      )
    }
  ) %>%
  # add interactive search function to table
  opt_interactive(
    use_search = TRUE,
    use_page_size_select = TRUE
  )

# Define UI for application that draws a histogram
ui <- fluidPage(
  # create two tabs
  navbarPage(
    # name of the application (MAYBE MAKE IT BETTER)
    "GamerGate Grunge Goblins",
    # tab 1
    tabPanel("Search the Training Data",
             # Content for Tab 1
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
                         ),
              # define main page for gt table output
             mainPanel(
               # display gt table
               gt_output("gt_table"),
                      ),
          ),
    tabPanel("ML Model Simulation",
             # Content for Tab 4
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
server <- function(input, output, session) {
  games %>%
    
  # testing functionality
  output$description <- renderText({
    games_reactive()
  })
  
  # render gt table output
  output$gt_table <- render_gt(games_table)
}

# Run the application 
shinyApp(ui = ui, server = server)
