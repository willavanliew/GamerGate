# SHINY APPLICATION
# Installing dependencies
library(shiny)
library(tidyverse)
library(colorspace)
library(RColorBrewer)
library(maps)
library(sf)
library(leaflet)
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
