if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,rio,ggpubr,thematic,shinythemes,shiny)
games_gt <- read_csv("gt.csv")
dev_names <- import("developer_titles.csv")$Name
dev_codes <- import("developer_titles.csv")$Column
names(dev_codes) <- dev_names
pub_names <- import("publisher_titles.csv")$Name
pub_codes <- import("publisher_titles.csv")$Column
names(pub_codes) <- pub_names
platform_names <- games_gt %>% select(c(86:131)) %>% names()
names(platform_names) <- platform_names
genres_names <- games_gt %>% select(c(135:140)) %>% names()
names(genres_names)<- genres_names

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


### PLAYING AROUND WITH FUNCTIONS
# A function that works to search the developer columns
search_dev <- function(x) {
  dev_index <- 6:40  # Definition of dev_index
  
  # add dev_ to user input
  x <- paste0("dev_", x)
  
  # Initialize result variable
  result <- NULL
  
  # Check if x matches any of the modified column names
  if (x == "dev_All") {
    # Return the entire data frame if "All" is provided
    return(games_gt)
  } else if (x %in% colnames(games_gt[, dev_index])) {
    # Filter the data frame to get games by the specified developer
    result <- games_gt[games_gt[, dev_index][, x] == "Yes", ]
  } else {
    # Developer not found
    cat("Developer not found:", gsub("dev_", "",x), "\n")
    return(NULL)
  }
  
  return(result)
}

search_dev("Atlus")

# A function that works to search the publisher columns
search_pub <- function(x) {
  pub_index <- 41:85  # Definition of pub_index
  
  # add dev_ to user input
  x <- paste0("pub_", x)
  
  # Initialize result variable
  result <- NULL
  
  # Check if x matches any of the modified column names
  if (x == "pub_All") {
    # Return the entire data frame if "All" is provided
    return(games_gt)
  } else if (x %in% colnames(games_gt[, pub_index])) {
    # Filter the data frame to get games by the specified publisher
    result <- games_gt[games_gt[, pub_index][, x] == "Yes", ]
  } else {
    # Publisher not found
    cat("Publisher not found:", gsub("pub_", "",x), "\n")
    return(NULL)
  }
  return(result)
}

search_pub("Atlus")

# A function that works to search the platform columns
search_platform <- function(x) {
  # index of platforms
  platform_index <- 86:131
  
  # Initialize result variable
  result <- NULL
  
  # Check if x matches any of the modified column names
  if (x == "All") {
    # Return the entire data frame if "All" is provided
    return(games_gt)
  } else if (x %in% colnames(games_gt[, platform_index])) {
    # Filter the data frame to get games by the specified platform
    result <- games_gt[games_gt[, platform_index][, x] == "Yes", ]
  } else {
    # Publisher not found
    cat("Platform not found:", x, "\n")
    return(NULL)
  }
  
  return(result)
}

search_platform("PlayStation 5") # PS5 does not work but maybe we can add another column for it if we desire
# NOTE: Do we want to add in more dummies for PS5, PS4 as well as PlayStation 5 since people may search that?
# Consider: converting to all caps in reactive func to make search case insensitive

# A function that works to search the gaming mode columns
search_mode <- function(x) {
  # index of modes
  mode_index <- 132:134
  
  # Check if x matches any of the modified column names
  if (x %in% colnames(games_gt[, mode_index])) {
    result <- games_gt[games_gt[, mode_index][, x] == "Yes", ]
    return(result)
  } else {
    cat("Mode not found:", x, "\n")
    return(NULL)
  }
}

search_mode("2-player co-op")
# in reactive function we definitely want a select drop down for gaming mode, not a search func

# A function that works to search the gaming mode columns
search_genre <- function(x) {
  # index of genre
  genre_index <- 135:140
  
  # Check if x matches any of the modified column names
  if (x %in% colnames(games_gt[, genre_index])) {
    result <- games_gt[games_gt[, genre_index][, x] == "Yes", ]
    return(result)
  } else {
    cat("Genre not found:", x, "\n")
    return(NULL)
  }
}

gt_reactive <- reactive() {
  # taking in the games_gt 
  # take each of the individual functions and have the input values into the functions 
}
search_genre("Action")

# create initial GT table object
games_table <- games_gt %>% # replace this with reactive dataset that is formed from search func
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
                 selectizeInput("genre", h3("Choose a genre"), 
                                choices = c("", genres_names),
                                selected = NULL), 
                 selectizeInput("mode", h3("Choose a Mode"), 
                                choices = c("",
                                            "Single-player" = "Single-player",
                                            "2-player co-op"="2-player co-op", 
                                            "Multiplayer"="Multiplayer"),
                                selected = NULL), 
                 # Searches 
                 selectizeInput("console", h3("Choose a Console Type"),
                                choices = c("", platform_names),
                                select = NULL),
                 selectizeInput("publisher", h3("Choose a Publisher"),
                                choices = c("", pub_codes), 
                                select = NULL),
                 selectizeInput("developer", h3("Choose a Developer"),
                                choices = c("", dev_codes),
                                select = NULL)
                          )
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
