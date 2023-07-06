# SHINY APPLICATION
# Installing dependencies
library(shiny)
library(tidyverse)
library(colorspace)
library(RColorBrewer)
library(htmltools)
library(plotly)
library(ggpubr)
library(thematic)
library(shinythemes)

# Reading in datasets
games_old <- read_csv("cleaned_games.csv")

games_new <- read_csv("game_data.csv")

# Create datset for use in Shiny App
# Select specific columns from the 'games_new' data frame
games <- games_new %>% 
  select(name, metacritic, platform_name, platform_released_at, esrb_rating_name)

# Select specific columns from the 'games_old' data frame
games2 <- games_old %>% 
  select(Title, review_score, release_console, year, esrb_rating)

# Convert the 'year' column in 'games2' to a Date format
games2$year <- as.Date(paste(games2$year, 1, 1, sep = "-"))

# Rename the column names of 'games2' to match 'games'
colnames(games2) <- c("name", "metacritic", "platform_name", "platform_released_at", "esrb_rating_name")

# Merge the 'games' and 'games2' data frames vertically
games <- rbind(games, games2)

# Rename columns to easy variable names
colnames(games)<-c("title", "score", "platform", "date", "esrb")

# Change ESRB rating to consistent naming convention
games <- games %>% mutate(esrb = case_when(
  esrb == "Mature" ~ "Mature",
  esrb == "Everyone 10+" ~ "Everyone 10+",
  esrb == "Everyone" ~ "Everyone",
  esrb == "Teen" ~ "Teen",
  esrb == "Adults Only" ~ "Adults Only",
  esrb == "Rating Pending" ~ "Rating Pending",
  esrb == "M" ~ "Mature",
  esrb == "E" ~ "Everyone",
  esrb == "T" ~ "Teen")
)

# Replace platform names to consistent naming convention
games$platform <- str_replace(games$platform, 'X360', 'Xbox 360')
games$platform <- str_replace(games$platform, 'Wii', 'Nintendo Wii')

# Add platform logos by URL
games <- games %>% 
  mutate(platform_logo = 
           case_when(
             platform == "PlayStation 5" ~ "https://upload.wikimedia.org/wikipedia/commons/c/cb/PlayStation_5_logo_and_wordmark.svg",
             platform == "PlayStation 4" ~ "https://upload.wikimedia.org/wikipedia/commons/8/87/PlayStation_4_logo_and_wordmark.svg",
             platform == "Xbox Series S/X" ~ "https://upload.wikimedia.org/wikipedia/commons/f/f3/Xbox_Series_X_S_black.svg",
             platform == "PC" ~ "https://upload.wikimedia.org/wikipedia/commons/3/38/Pc_game_logo.png",
             platform == "PlayStation 3" ~ "https://upload.wikimedia.org/wikipedia/commons/0/05/PlayStation_3_logo_%282009%29.svg",
             platform == "Xbox 360" ~ "https://upload.wikimedia.org/wikipedia/en/0/0c/Xbox_360_full_logo.svg",
             platform == "Xbox One" ~ "https://upload.wikimedia.org/wikipedia/commons/4/43/Xbox_One_logo_wordmark.svg",
             platform == "Nintendo Switch" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/NintendoSwitchLogo.svg",
             platform == "Linux" ~ "https://upload.wikimedia.org/wikipedia/commons/d/dd/Linux_logo.jpg",
             platform == "macOS" ~ "https://upload.wikimedia.org/wikipedia/commons/3/30/MacOS_logo.svg",
             platform == "Android" ~ "https://upload.wikimedia.org/wikipedia/commons/6/64/Android_logo_2019_%28stacked%29.svg",
             platform == "PS Vita" ~ "https://upload.wikimedia.org/wikipedia/commons/3/3d/PlayStation_Vita_logo.svg",
             platform == "iOS" ~ "https://upload.wikimedia.org/wikipedia/commons/6/63/IOS_wordmark_%282017%29.svg",
             platform == "Xbox" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8c/XBOX_logo_2012.svg",
             platform == "Web" ~ "https://upload.wikimedia.org/wikipedia/commons/c/c4/Globe_icon.svg",
             platform == "Wii U" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/WiiU.svg",
             platform == "Nintendo 3DS" ~ "https://upload.wikimedia.org/wikipedia/commons/1/19/Nintendo_3ds_logo.svg",
             platform == "PlayStation 2" ~ "https://upload.wikimedia.org/wikipedia/commons/7/76/PlayStation_2_logo.svg",
             platform == "Dreamcast" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/Dreamcast_logo.svg",
             platform == "Classic Macintosh" ~ "https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg",
             platform == "Nintendo DS" ~ "https://upload.wikimedia.org/wikipedia/commons/a/af/Nintendo_DS_Logo.svg",
             platform == "GameCube" ~ "https://upload.wikimedia.org/wikipedia/en/e/e6/Nintendo_Gamecube_Logo.svg",
             platform == "Nintendo 64" ~ "https://upload.wikimedia.org/wikipedia/en/0/04/Nintendo_64_Logo.svg",
             platform == "PlayStation" ~ "https://upload.wikimedia.org/wikipedia/commons/4/4e/Playstation_logo_colour.svg",
             platform == "Game Boy Advance" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/Gameboy_advance_logo.svg",
             platform == "Sony PSP" ~ "https://upload.wikimedia.org/wikipedia/commons/0/0e/PSP_Logo.svg",
             platform == "Nintendo Wii" ~ "https://upload.wikimedia.org/wikipedia/commons/b/bc/Wii.svg"
           )
  )


# ANY DATA WRANGLING NEEDED
# creating input for year slider
unique_years <- unique(games$year)

games

# SHINY UI
ui <- fluidPage(
  navbarPage(
    "GamerGate Grunge Goblins",
    tabPanel("Overview",
            # Content for Tab 1
    ),
    tabPanel("Comparison",
             # Content for Tab 2
             sidebarLayout(
               sidebarPanel(
                 # Slider input for selecting the year
                 sliderInput("year_slider", "Select Year", 
                             min = min(unique_years), 
                             max = max(unique_years),
                             value = c(min(unique_years), max(unique_years)),
                             step = 1),
                 # Text input for search query
                 textInput("search_input", "Search by Title",
                           placeholder = "Enter a title")
               ),
               mainPanel(
                 # Output to display the filtered data based on the selected year
                 verbatimTextOutput("filtered_data")
               )
             )
    ),
    tabPanel("ML Model",
             # Content for Tab 3
    )
  )
)

server <- function(input, output, session) {
  # Filter the data based on the selected year
  filtered_data <- reactive({
    year_filtered <- subset(games, year == input$year_slider)
    if (!is.null(input$search_input) && input$search_input != "") {
      title_filtered <- subset(year_filtered,
      grepl(input$search_input, title, ignore.case = TRUE))
    } else {
      title_filtered <- year_filtered
    }
    title_filtered
  })
  
  # Display the filtered data
  output$filtered_data <- renderPrint({
    filtered_data()
  })
}

shinyApp(ui, server)
