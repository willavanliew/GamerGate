library(tidyverse)
library(colorspace)
library(RColorBrewer)
library(htmltools)
library(plotly)
library(ggpubr)
library(thematic)
library(shinythemes)
library(gt)
library(stringr)

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

# Change ESRB rating to consistent naming convention and correct X360 platform name
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

# replace names to consistent naming convention
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


# create data set without NA values for some functions
noNA_games <- na.omit(games)

# create initial GT table object
gt_games <- games %>%
  gt() %>% 
  # add title and subtitle
  tab_header(
    title = md("**GamerGate 2023 Games**"),
    subtitle = "Explore the data used to train the algorithm"
  ) %>% 
  # format date
  fmt_date(
    columns = date,
    date_style = 5
  ) %>% 
  # color score column based on values
  data_color(
    columns = score,
    fn = scales::col_bin(
      palette = "PuBu",
      domain = range(noNA_games$score),
      bins = c(0, 25, 50, 70, 80, 90, 100)
    ),
    alpha = 0.9
  ) %>% 
  # add official column names
  cols_label(
    title = md("**Game Title**"),
    score = md("**Metacritic Rating**"),
    platform = "Gaming Platforms",
    date = "Release Date",
    esrb = "ESRB Rating"
  ) %>% 
  text_transform(
    # Apply a function to a column
    locations = cells_body(platform_logo),
         fn = function(x) {
           #Return an image of set dimensions
           web_image(
             url = x,
             height = 12
           )
         }
       )

# display the table
gt_games

# add interactive search function to table
opt_interactive(gt_games,
    use_search = TRUE,
    use_page_size_select = TRUE
)