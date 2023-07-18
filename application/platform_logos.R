# # Add platform_name logos by URL
# games_gt <- games_gt %>% 
#   mutate(platform_logo = 
#          case_when(
#            platform_name == "PlayStation 5" ~ "https://upload.wikimedia.org/wikipedia/commons/c/cb/PlayStation_5_logo_and_wordmark.svg",
#            platform_name == "PlayStation 4" ~ "https://upload.wikimedia.org/wikipedia/commons/8/87/PlayStation_4_logo_and_wordmark.svg",
#            platform_name == "Xbox Series S/X" ~ "https://upload.wikimedia.org/wikipedia/commons/f/f3/Xbox_Series_X_S_black.svg",
#            platform_name == "PC" ~ "https://upload.wikimedia.org/wikipedia/commons/3/38/Pc_game_logo.png",
#            platform_name == "PlayStation 3" ~ "https://upload.wikimedia.org/wikipedia/commons/0/05/PlayStation_3_logo_%282009%29.svg",
#            platform_name == "Xbox 360" ~ "https://upload.wikimedia.org/wikipedia/en/0/0c/Xbox_360_full_logo.svg",
#            platform_name == "Xbox One" ~ "https://upload.wikimedia.org/wikipedia/commons/4/43/Xbox_One_logo_wordmark.svg",
#            platform_name == "Nintendo Switch" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/NintendoSwitchLogo.svg",
#            platform_name == "Linux" ~ "https://upload.wikimedia.org/wikipedia/commons/d/dd/Linux_logo.jpg",
#            platform_name == "macOS" ~ "https://upload.wikimedia.org/wikipedia/commons/3/30/MacOS_logo.svg",
#            platform_name == "Android" ~ "https://upload.wikimedia.org/wikipedia/commons/6/64/Android_logo_2019_%28stacked%29.svg",
#            platform_name == "PS Vita" ~ "https://upload.wikimedia.org/wikipedia/commons/3/3d/PlayStation_Vita_logo.svg",
#            platform_name == "iOS" ~ "https://upload.wikimedia.org/wikipedia/commons/6/63/IOS_wordmark_%282017%29.svg",
#            platform_name == "Xbox" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8c/XBOX_logo_2012.svg",
#            platform_name == "Web" ~ "https://upload.wikimedia.org/wikipedia/commons/c/c4/Globe_icon.svg",
#            platform_name == "Wii U" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/WiiU.svg",
#            platform_name == "Nintendo 3DS" ~ "https://upload.wikimedia.org/wikipedia/commons/1/19/Nintendo_3ds_logo.svg",
#            platform_name == "PlayStation 2" ~ "https://upload.wikimedia.org/wikipedia/commons/7/76/PlayStation_2_logo.svg",
#            platform_name == "Dreamcast" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/Dreamcast_logo.svg",
#            platform_name == "Classic Macintosh" ~ "https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg",
#            platform_name == "Nintendo DS" ~ "https://upload.wikimedia.org/wikipedia/commons/a/af/Nintendo_DS_Logo.svg",
#            platform_name == "GameCube" ~ "https://upload.wikimedia.org/wikipedia/en/e/e6/Nintendo_Gamecube_Logo.svg",
#            platform_name == "Nintendo 64" ~ "https://upload.wikimedia.org/wikipedia/en/0/04/Nintendo_64_Logo.svg",
#            platform_name == "PlayStation" ~ "https://upload.wikimedia.org/wikipedia/commons/4/4e/Playstation_logo_colour.svg",
#            platform_name == "Game Boy Advance" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/Gameboy_advance_logo.svg",
#            platform_name == "Sony PSP" ~ "https://upload.wikimedia.org/wikipedia/commons/0/0e/PSP_Logo.svg",
#            platform_name == "Wii" ~ "https://upload.wikimedia.org/wikipedia/commons/b/bc/Wii.svg",
#            platform_name == "3DO" ~ "https://upload.wikimedia.org/wikipedia/en/4/4d/3DO_Interactive_Multiplayer_logo.png",
#            platform_name == "Game Boy Color" ~ "https://upload.wikimedia.org/wikipedia/commons/c/c5/Game_Boy_Color_logo.svg",
#            platform_name == "SNES" ~ "https://upload.wikimedia.org/wikipedia/commons/3/33/Super_Nintendo_Entertainment_System_logo.svg",
#            platform_name == "SEGA Saturn" ~ "https://upload.wikimedia.org/wikipedia/en/4/42/SegaSaturn.png",
#            platform_name == "SEGA 32X" ~ "https://upload.wikimedia.org/wikipedia/commons/a/a4/Sega_32X_logo.svg",
#            platform_name == "Jaguar" ~ "https://upload.wikimedia.org/wikipedia/en/d/dc/Jaguar_Logo.png",
#            platform_name == "Genesis" ~ "https://upload.wikimedia.org/wikipedia/en/1/12/GenesisLogo.png",
#            platform_name == "Game Boy" ~ "https://upload.wikimedia.org/wikipedia/commons/f/f2/Nintendo_Game_Boy_Logo.svg",
#            platform_name == "NES" ~ "https://upload.wikimedia.org/wikipedia/commons/0/0d/NES_logo.svg",
#            platform_name == "Commodore / Amiga" ~ "https://upload.wikimedia.org/wikipedia/commons/c/cc/Commodore_Amiga_logo-03.svg",
#            platform_name == "Game Gear" ~ "https://upload.wikimedia.org/wikipedia/commons/b/b8/Game_Gear_logo_Sega.png",
#            platform_name == "Nintendo DSi" ~ "https://upload.wikimedia.org/wikipedia/commons/d/dd/Nintendo_DSi_logo.svg",
#            platform_name == "SEGA Master System" ~ "https://upload.wikimedia.org/wikipedia/commons/3/3e/Sega-master-system-logo.png"
#          )
# ) %>% 
#   mutate(cons_comp = 
#            case_when(
#              platform_name %in% c("PlayStation 5", "PlayStation 4", "PlayStation 3", "PS Vita",
#                                   "PlayStation 2", "PlayStation", "Sony PSP") ~ "Sony",
#              platform_name %in% c("Xbox Series S/X", "Xbox 360", "Xbox One", "Xbox") ~ "Microsoft",
#              platform_name %in% c("Nintendo Switch", "Wii U", "Nintendo 3DS", "Nintendo DS",
#                                   "GameCube", "Nintendo 64", "Wii", "Game Boy Advance",
#                                   "Game Boy Color", "SNES", "Game Boy", "NES",
#                                   "Nintendo DSi") ~ "Nintendo",
#              platform_name %in% c("Dreamcast", "SEGA Saturn", "SEGA 32X",
#                                   "Genesis", "Game Gear", "SEGA Master System") ~ "SEGA",
#              platform_name %in% c("3DO", "Jaguar", "Commodore / Amiga") ~ "Other",
#              platform_name %in% c("Android", "iOS") ~ "Mobile",
#              platform_name %in% c("PC", "Linux", "macOS", "Web", "Classic Macintosh") ~ "Computer"
#              )
#   )

if(!require("pacman")) {install.packages("pacman");library(pacman)}
p_load(tidyverse, colorspace, RColorBrewer,htmltools,plotly,ggpubr,thematic,shinythemes,gt,stringr)

# Reading in datasets
games <- read_csv("master.csv")

# Create dataset for use in gt table
games_gt <- games %>%
  select(-c(id, description))

# Add platform_name logos by URL
games_gt <- games_gt %>% 
  mutate(platform_logo = 
         case_when(
           platform_name == "PlayStation 5" ~ "https://upload.wikimedia.org/wikipedia/commons/c/cb/PlayStation_5_logo_and_wordmark.svg",
           platform_name == "PlayStation 4" ~ "https://upload.wikimedia.org/wikipedia/commons/8/87/PlayStation_4_logo_and_wordmark.svg",
           platform_name == "Xbox Series S/X" ~ "https://upload.wikimedia.org/wikipedia/commons/f/f3/Xbox_Series_X_S_black.svg",
           platform_name == "PC" ~ "https://upload.wikimedia.org/wikipedia/commons/3/38/Pc_game_logo.png",
           platform_name == "PlayStation 3" ~ "https://upload.wikimedia.org/wikipedia/commons/0/05/PlayStation_3_logo_%282009%29.svg",
           platform_name == "Xbox 360" ~ "https://upload.wikimedia.org/wikipedia/en/0/0c/Xbox_360_full_logo.svg",
           platform_name == "Xbox One" ~ "https://upload.wikimedia.org/wikipedia/commons/4/43/Xbox_One_logo_wordmark.svg",
           platform_name == "Nintendo Switch" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/NintendoSwitchLogo.svg",
           platform_name == "Linux" ~ "https://upload.wikimedia.org/wikipedia/commons/d/dd/Linux_logo.jpg",
           platform_name == "macOS" ~ "https://upload.wikimedia.org/wikipedia/commons/3/30/MacOS_logo.svg",
           platform_name == "Android" ~ "https://upload.wikimedia.org/wikipedia/commons/6/64/Android_logo_2019_%28stacked%29.svg",
           platform_name == "PS Vita" ~ "https://upload.wikimedia.org/wikipedia/commons/3/3d/PlayStation_Vita_logo.svg",
           platform_name == "iOS" ~ "https://upload.wikimedia.org/wikipedia/commons/6/63/IOS_wordmark_%282017%29.svg",
           platform_name == "Xbox" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8c/XBOX_logo_2012.svg",
           platform_name == "Web" ~ "https://upload.wikimedia.org/wikipedia/commons/c/c4/Globe_icon.svg",
           platform_name == "Wii U" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/WiiU.svg",
           platform_name == "Nintendo 3DS" ~ "https://upload.wikimedia.org/wikipedia/commons/1/19/Nintendo_3ds_logo.svg",
           platform_name == "PlayStation 2" ~ "https://upload.wikimedia.org/wikipedia/commons/7/76/PlayStation_2_logo.svg",
           platform_name == "Dreamcast" ~ "https://upload.wikimedia.org/wikipedia/commons/7/7e/Dreamcast_logo.svg",
           platform_name == "Classic Macintosh" ~ "https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg",
           platform_name == "Nintendo DS" ~ "https://upload.wikimedia.org/wikipedia/commons/a/af/Nintendo_DS_Logo.svg",
           platform_name == "GameCube" ~ "https://upload.wikimedia.org/wikipedia/en/e/e6/Nintendo_Gamecube_Logo.svg",
           platform_name == "Nintendo 64" ~ "https://upload.wikimedia.org/wikipedia/en/0/04/Nintendo_64_Logo.svg",
           platform_name == "PlayStation" ~ "https://upload.wikimedia.org/wikipedia/commons/4/4e/Playstation_logo_colour.svg",
           platform_name == "Game Boy Advance" ~ "https://upload.wikimedia.org/wikipedia/commons/8/8a/Gameboy_advance_logo.svg",
           platform_name == "Sony PSP" ~ "https://upload.wikimedia.org/wikipedia/commons/0/0e/PSP_Logo.svg",
           platform_name == "Wii" ~ "https://upload.wikimedia.org/wikipedia/commons/b/bc/Wii.svg",
           platform_name == "3DO" ~ "https://upload.wikimedia.org/wikipedia/en/4/4d/3DO_Interactive_Multiplayer_logo.png",
           platform_name == "Game Boy Color" ~ "https://upload.wikimedia.org/wikipedia/commons/c/c5/Game_Boy_Color_logo.svg",
           platform_name == "SNES" ~ "https://upload.wikimedia.org/wikipedia/commons/3/33/Super_Nintendo_Entertainment_System_logo.svg",
           platform_name == "SEGA Saturn" ~ "https://upload.wikimedia.org/wikipedia/en/4/42/SegaSaturn.png",
           platform_name == "SEGA 32X" ~ "https://upload.wikimedia.org/wikipedia/commons/a/a4/Sega_32X_logo.svg",
           platform_name == "Jaguar" ~ "https://upload.wikimedia.org/wikipedia/en/d/dc/Jaguar_Logo.png",
           platform_name == "Genesis" ~ "https://upload.wikimedia.org/wikipedia/en/1/12/GenesisLogo.png",
           platform_name == "Game Boy" ~ "https://upload.wikimedia.org/wikipedia/commons/f/f2/Nintendo_Game_Boy_Logo.svg",
           platform_name == "NES" ~ "https://upload.wikimedia.org/wikipedia/commons/0/0d/NES_logo.svg",
           platform_name == "Commodore / Amiga" ~ "https://upload.wikimedia.org/wikipedia/commons/c/cc/Commodore_Amiga_logo-03.svg",
           platform_name == "Game Gear" ~ "https://upload.wikimedia.org/wikipedia/commons/b/b8/Game_Gear_logo_Sega.png",
           platform_name == "Nintendo DSi" ~ "https://upload.wikimedia.org/wikipedia/commons/d/dd/Nintendo_DSi_logo.svg",
           platform_name == "SEGA Master System" ~ "https://upload.wikimedia.org/wikipedia/commons/3/3e/Sega-master-system-logo.png"
         )
) %>% 
  mutate(cons_comp = 
           case_when(
             platform_name %in% c("PlayStation 5", "PlayStation 4", "PlayStation 3", "PS Vita",
                                  "PlayStation 2", "PlayStation", "Sony PSP") ~ "Sony",
             platform_name %in% c("Xbox Series S/X", "Xbox 360", "Xbox One", "Xbox") ~ "Microsoft",
             platform_name %in% c("Nintendo Switch", "Wii U", "Nintendo 3DS", "Nintendo DS",
                                  "GameCube", "Nintendo 64", "Wii", "Game Boy Advance",
                                  "Game Boy Color", "SNES", "Game Boy", "NES",
                                  "Nintendo DSi") ~ "Nintendo",
             platform_name %in% c("Dreamcast", "SEGA Saturn", "SEGA 32X",
                                  "Genesis", "Game Gear", "SEGA Master System") ~ "SEGA",
             platform_name %in% c("3DO", "Jaguar", "Commodore / Amiga") ~ "Other",
             platform_name %in% c("Android", "iOS") ~ "Mobile",
             platform_name %in% c("PC", "Linux", "macOS", "Web", "Classic Macintosh") ~ "Computer"
             )
  )

head(games_gt)

# write to csv
# write_csv(games_gt, "gt.csv")

# create initial GT table object
games_table <- games_gt %>%
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
    platform_name = "Gaming Platforms",
    esrb_rating_name = "ESRB Rating",
    playtime = "Game Duration (mins)",
    background_image = "Background Image",
    genre = "Genre",
    metacritic_category = "Metacritic Category",
    season = "Time of Release",
    platform_logo = "Platform Logo"
  ) %>% 
  # put metacritic columns next to each other
  cols_move(metacritic_category, metacritic) %>%
  # put platform logo next to platform name
  cols_move(platform_logo, platform_name) %>% 
  # Add images to GT table
  text_transform(
    # Apply a function to a column to return the platform logo
    locations = cells_body(platform_logo),
         fn = function(x) {
           #Return an image of set dimensions
           web_image(
             url = x,
             height = 12
           )
         }
       ) %>% 
       text_transform(
    # Apply a function to a column to return the game logo
    locations = cells_body(background_image),
         fn = function(x) {
           # Return an image of set dimensions
           web_image(
             url = x,
             height = 12
           )
         }
       )

# display the table
games_table

# add interactive search function to table
opt_interactive(games_table,
    use_search = TRUE,
    use_page_size_select = TRUE
)
