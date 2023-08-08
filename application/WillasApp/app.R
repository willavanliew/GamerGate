if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,rio,ggpubr,thematic,shinythemes,shiny,gt)
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

dev_names <- games_gt[, dev_index] %>% names
names(dev_names) <- gsub("dev_","",dev_names)
pub_names <- games_gt[, pub_index] %>% names
names(pub_names) <- gsub("pub_", "", pub_names)
platform_names <- games_gt[, platform_index] %>% names()
names(platform_names) <- games_gt[, platform_index] %>% names()
genres_names <- games_gt[, genre_index] %>% names()
names(genres_names)<- games_gt[, genre_index] %>% names()


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
    return(games_gt)
  }
  
  return(result)
}

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
    #cat("Publisher not found:", gsub("pub_", "",x), "\n")
    return(games_gt)
  }
  return(result)
}

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
    #cat("Platform not found:", x, "\n")
    return(games_gt)
  }
  
  return(result)
}
# PS5 does not work but maybe we can add another column for it if we desire
# NOTE: Do we want to add in more dummies for PS5, PS4 as well as PlayStation 5 since people may search that?
# Consider: converting to all caps in reactive func to make search case insensitive

# A function that works to search the gaming mode columns
search_mode <- function(x) {
  # index of modes
  mode_index <- 132:134
  
  # Check if x matches any of the modified column names
  if (x %in% colnames(games_gt[, mode_index])) {
    result <- games_gt[games_gt[, mode_index][, x] == "Yes", ]
  } else {
    #cat("Mode not found:", x, "\n")
    return(games_gt)
  }
  
  return(result)
}

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
    return(games_gt)
    #cat("Genre not found:", x, "\n")
    #return(NULL)
  }
}

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
                 selectizeInput("genre", h4("Choose a Genre"), 
                                choices = c("", genres_names),
                                #choices = colnames(games_gt[, genre_index]),
                                selected = NULL), 
                 selectizeInput("mode", h4("Choose a Mode"), 
                                choices = c("", colnames(games_gt[, mode_index])),
                                selected = NULL), 
                 # Searches 
                 selectizeInput("console", h4("Choose a Console Type"),
                                choices = c("", colnames(games_gt[, platform_index])),
                                select = NULL),
                 selectizeInput("publisher", h4("Choose a Publisher"),
                                choices = c("", gsub("pub_", "", colnames(games_gt[, pub_index]))), 
                                select = NULL),
                 selectizeInput("developer", h4("Choose a Developer"),
                                choices = c("",gsub("dev_", "", colnames(games_gt[, dev_index]))),
                                select = NULL),
                 textOutput("text")
               ),
               
               # define main page for gt table output
               mainPanel(
                 # display gt for selected table
                 uiOutput("selected_table"),
               ),
             ),
    ),
  ),
)

# Define server logic required to draw a gt table
server <- function(input, output, session) {
  
  # create gt table object
  create_games_gt <- function(df) {
    df %>%
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
          domain = range(games_gt$metacritic, na.rm = TRUE),
          bins = c(0, 67, 68, 73, 77, 81, 85, 100)
        ),
        alpha = 0.9
      ) %>%
      # add official column names
      cols_label(
        name = md("**Game Title**"),
        metacritic = md("**Metacritic Rating**"),
        released = "Release Date",
        esrb_rating_name = "ESRB Rating",
        background_image = "Background Image"
      ) %>%
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
  }
  
  # Observe events for each input (developer, publisher, console, mode, and genre)
  observeEvent(input$developer, {
    dev_result <- search_dev(input$developer)
    if (!is.null(dev_result)) {
      output$selected_table <- render_gt({
        create_games_gt(dev_result)
      })
      output$text <- renderText(paste0("You have selected Developer: ",input$developer))
    }
  })
  
  observeEvent(input$publisher, {
    pub_result <- search_pub(input$publisher)
    if (!is.null(pub_result)) {
      output$selected_table <- render_gt({
        create_games_gt(pub_result)
      })
      output$text <- renderText(paste0("You have selected Publisher: ",input$publisher))
    }
  })
  
  observeEvent(input$console, {
    console_result <- search_platform(input$console)
    if (!is.null(console_result)) {
      output$selected_table <- render_gt({
        create_games_gt(console_result)
      })
      output$text <- renderText(paste0("You have selected Platform: ",input$console))
    }
  })
  
  observeEvent(input$mode, {
    mode_result <- search_mode(input$mode)
    if (!is.null(mode_result)) {
      output$selected_table <- render_gt({
        create_games_gt(mode_result)
      })
      output$text <- renderText(paste0("You have selected Gaming Mode: ",input$mode))
    }
  })
  
  observeEvent(input$genre, {
    genre_result <- search_genre(input$genre)
    if (!is.null(genre_result)) {
      output$selected_table <- render_gt({
        create_games_gt(genre_result)
      })
      output$text <- renderText(paste0("You have selected Genre: ",input$genre))
    }
  })
  
  # Initialize the table with all data at startup
  output$selected_table <- render_gt({
    create_games_gt(games_gt)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
