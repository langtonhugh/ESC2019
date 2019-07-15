stop.df <- read_csv("https://github.com/langtonhugh/ESC2019/raw/master/2018-12-greater-manchester-stop-and-search_edit.csv")

stop.df <- stop.df %>% 
  drop_na(latitude, longitude)

stop.sf <- st_as_sf(stop.df, coords = c("longitude", "latitude"), crs = 4326)

plot(st_geometry(stop.sf))


# library(tidycensus)
# census_api_key("32102ee72ad1cb61a4791aae37eb0441261baf0c")
# 
# chicago.sf <- get_crime_data(
#   cities = "Chicago", 
#   years = 2017, 
#   type = "core",
#   output = "sf") 
# 
# chicago.shop.sf <- chicago.sf %>% 
#   filter(offense_type == "shoplifting")
# 
# il.sf <- get_acs(state = "IL", county = "Cook", geography = "tract", 
#                  variables = "B19013_001",  geometry = TRUE)
# 
# ggplot() +
#   geom_sf()



