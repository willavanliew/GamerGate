if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,ggpubr,thematic,shinythemes,gt,stringr)

# Reading in datasets
games <- read_csv("Final_dev_pub.csv")

# Create dataset for use in gt table
games_gt <- games %>%
  select(-c(id, developers, publishers, genres, playtime))


# cons_comp as headers
# color t/f

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

# Convert Fs to "no" and Ts to "yes" using mutate_at
games_gt <- games_gt %>%
  mutate_at(vars(6:length(games_gt)), ~ ifelse(. == TRUE, "Yes", "No"))

# Remove the prefix from column names
colnames(games_gt) <- sub("^(dev_|pub_)", "", colnames(games_gt))

View(games_gt)



# write to csv
write_csv(games_gt, "gt.csv")

# create initial GT table object
games_table <- games_gt %>%
  gt() %>% 
  # add title and subtitle
  tab_header(
    title = md("**GamerGate 2023 Games**"),
    subtitle = "Explore the data used to train the algorithm"
  ) %>% 
  # add developer tab spanner
  tab_spanner("Developers",
              columns=dev_index) %>%
  # add publisher tab spanner
  tab_spanner("Publishers",
              columns=pub_index) %>%
  # add platform spanner
  tab_spanner("Platforms",
              columns=platform_index) %>%
  # add gaming mode spanner
  tab_spanner("Gaming Mode",
              columns=mode_index) %>%
  # add genre spanner
  tab_spanner("Genre",
              columns=genre_index)
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
             height = 40
           )
         }
       ) %>%
  # add interactive search function to table
  opt_interactive(
    use_search = TRUE,
    use_page_size_select = TRUE
  )

# display the table
games_table