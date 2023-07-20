if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse,colorspace,RColorBrewer,htmltools,plotly,ggpubr,thematic,shinythemes,gt,stringr)

# Reading in datasets
games <- read_csv("Final_dev_pub.csv")

# Create dataset for use in gt table
games_gt <- games %>%
  select(-c(id, developers, publishers, genres, playtime))

# sub dev_ for Developer:
colnames(games_gt) <- sub("^(dev_)", "Developer: ", colnames(games_gt))
colnames(games_gt) <- sub("^(pub_)", "Publisher: ", colnames(games_gt))


# cons_comp as headers
# color t/f

# things to add into reactive func:
# genre, console company, dev, pub, esrb, metacritic?, platform
# even without model has practically
# best rated game first
# most interesting combo of features
# typical games with these feats are rating X based upon the toggled options
# incorporate the model

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

# # Convert Fs to "no" and Ts to "yes" using mutate_at
# games_gt <- games_gt %>%
#   mutate_at(vars(6:length(games_gt)), ~ ifelse(. == TRUE, "Yes", "No"))

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
  cols_move(
    `PlayStation 5`, `PlayStation 4`, `PlayStation 3`, `PS Vita`,
    `PlayStation 2`, `PlayStation`, `Sony PSP`,
    after = 
  ) %>% 
  # add interactive search function to table
  opt_interactive(
    use_search = TRUE,
    use_page_size_select = TRUE
  )

# display the table
games_table
