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
library(gt)

# Reading in datasets
games_gt <- read_csv("gt.csv")

# create initial GT table object
games_table <- games_gt %>%
  select(-c(platform_name, platform_logo, background_image)) %>% 
           distinct() %>%
  gt() %>% 
  # add title and subtitle
  tab_header(
    title = md("**GamerGate 2023 Games**"),
    subtitle = "Explore the data used to train the algorithm"
  ) %>% 
  # color metacritic column based on values
  data_color(
    columns = metacritic,
    fn = scales::col_bin(
      palette = "PuBu",
      domain = range(games$metacritic),
      bins = c(0, 25, 50, 70, 80, 90, 100)
    ),
    alpha = 0.9
  ) %>% 
  # add official column names
  cols_label(
    name = md("**Game Title**"),
    metacritic = md("**Metacritic Rating**"),
    # platform_name = "Gaming Platforms",
    esrb_rating_name = "ESRB Rating",
    playtime = "Game Duration (mins)",
    # background_image = "Background Image",
    genre = "Genre",
    metacritic_category = "Metacritic Category",
    season = "Time of Release",
    # platform_logo = "Platform Logo",
    cons_comp = "Console Metacategory"
  ) %>% 
  # put metacritic columns next to each other
  cols_move(metacritic_category, metacritic) %>%
  # put platform logo next to platform name
  # cols_move(platform_logo, platform_name) %>% 
  # Add images to GT table
  # text_transform(
  #   # Apply a function to a column to return the platform logo
  #   locations = cells_body(platform_logo),
  #   fn = function(x) {
  #     #Return an image of set dimensions
  #     web_image(
  #       url = x,
  #       height = 12
  #     )
  #   }
  # ) %>% 
  # text_transform(
  #   # Apply a function to a column to return the game logo
  #   locations = cells_body(background_image),
  #   fn = function(x) {
  #     # Return an image of set dimensions
  #     web_image(
  #       url = x,
  #       height = 12
  #     )
  #   }
  # ) %>%
  # add interactive search function to table
  opt_interactive(use_search = TRUE,
                  use_page_size_select = TRUE
  )

## display the table to check
#  games_table

# SHINY UI
ui <- fluidPage(
  navbarPage(
    "GamerGate Grunge Goblins",
    tabPanel("EDA (NEED BETTER NAME)",
             # Content for Tab 1
    ),
    tabPanel("Games over Time (NEED BETTER NAME)",
             # Content for Tab 2
    ),
    tabPanel("Search the Training Data",
             # Content for Tab 3
             mainPanel(
               # # toggle comparison table on or off
               # checkboxInput("show_table", "Show Table"),
               # display gt table
               gt_output("gt_table"),
               # # if toggled, display the second table
               # conditionalPanel(
               #   condition = "input.show_table",
               #   gt_output("comparison_table")
               # )
             )
    ),
    tabPanel("ML Model Simulation",
             # Content for Tab 4
    )
  )
)

server <- function(input, output, session) {
  
  # display the gt table
  output$gt_table <- render_gt(games_table)
  # # display table for comparison if toggled on
  # output$comparison_table <- render_gt({
  #   if (input$show_table) {
  #     games_table
  #   } else {
  #     gt()
  #   }
  # })
  
}

shinyApp(ui, server)
