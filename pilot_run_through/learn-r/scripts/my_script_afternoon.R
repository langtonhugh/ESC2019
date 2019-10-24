library(tidyverse)
library(crimedata)
library(sf)

stops <- read_csv(file = "original_data/stops-data.csv")

stops <- stops %>% 
  drop_na(latitude, longitude)

stops_sf <- st_as_sf(stops, coords = c(x = "longitude", y = "latitude"), crs = 4326)

stops_sf <- st_transform(stops_sf, 27700)

ggplot(data = stops_sf) +
  geom_sf()

download.file(url = "https://github.com/langtonhugh/ESC2019_materials/raw/master/manc_msoa_shp.zip", destfile = "original_data/manc_msoa_shp.zip")

unzip(zipfile = "original_data/manc_msoa_shp.zip", exdir = tempdir())

unzip(zipfile = "original_data/manc_msoa_shp.zip", list = TRUE)

manc_sf <- st_read(paste0(tempdir(), "/manc_msoa_shp/england_msoa_2011.shp"))

manc_sf <- st_transform(manc_sf, st_crs(stops_sf)) 

ggplot() +
  geom_sf(data = manc_sf, fill = "black") +            # Fill in polygons black
  geom_sf(data = stops_sf, colour = "red", size = 0.5)  # Colour dots red and make them smaller than default

stops_clip_sf <- st_intersection(stops_sf, manc_sf)

ggplot() +
  geom_sf(data = manc_sf) +
  geom_sf(data = stops_clip_sf)

ggplot() +
  geom_sf(data = manc_sf) +
  geom_sf(data = stops_clip_sf, mapping = aes(fill = objectofsearch), pch = 21)

manc_stops <- stops_clip_sf %>% 
  # Count the number of rows with each value of code, creating new variable 
  # stop_counts
  count(code, name = "stop_counts") %>%
  # Remove geometry column
  st_set_geometry(NULL)   

manc_sf <- manc_sf %>% 
  left_join(manc_stops, by = "code") %>% 
  replace_na(list(stop_counts = 0))

ggplot(data = manc_sf) +
  geom_sf(mapping = aes(fill = stop_counts))

ggplot(data = manc_sf) + 
  geom_sf(mapping = aes(fill = stop_counts)) +
  theme_minimal() +
  scale_fill_continuous(low = "snow", high = "red") +
  labs(title = "Stop and search incidents",
       subtitle = "Middle Super Output Areas, \nManchester, December 2018",
       fill = "counts",
       caption = "Data from www.police.uk")

stops_joined_sf <- st_join(stops_sf, manc_sf)

manc_simp_sf <- st_simplify(manc_sf, dTolerance = 120) 

centroids_sf <- st_centroid(manc_sf) # obtain centroids

ggplot(data = centroids_sf) +
  geom_sf()

centroids_buff_sf <- st_buffer(centroids_sf, dist = 500)

ggplot() +
  geom_sf(data = centroids_sf) +
  geom_sf(data = centroids_buff_sf, fill = "red", alpha = 0.4) # red and slightly transparent

example_sf <- manc_sf %>% 
  slice(1)

example_buff_sf <- st_buffer(example_sf, dist = 1000)

ggplot() +
  geom_sf(data = example_sf, size = 1.5) +                   # increase line width a bit
  geom_sf(data = example_buff_sf, fill = "red", alpha = 0.4) # red and slightly transparent

squ_manc_sf <- st_make_grid(manc_sf, cellsize = 1000)                   # Default is squares
hex_manc_sf <- st_make_grid(manc_sf, cellsize = 1000, square = FALSE)   # Alternative is hexagons

manc_sp <- as(manc_sf, 'Spatial')

manc_sf <- st_as_sf(manc_sp)
