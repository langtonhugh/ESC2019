library(tidyverse)
library(crimedata)

download.file(url = "https://github.com/langtonhugh/ESC2019_materials/raw/master/2018-12-greater-manchester-stop-and-search_edit.csv",
              destfile = "original_data/stops-data.csv")

stops <- read_csv(file = "original_data/stops-data.csv")

stop_arrests <- filter(stops, outcome == "Arrest")

stops_subset <- select(stops, gender, age, ethnic, outcome)

stops_ordered <- arrange(stops, day)

stops_ordered <- arrange(stops, desc(day))

stops_first10 <- slice(stops, 1:10)

stops_renamed <- rename(stops, clothing_remove = clothing_rm)

stops_with_id <- mutate(stops, ID = 1:nrow(stops))

stops <- mutate(stops, age_recode = recode(
  age,
  `10-17`    = "Below 18",
  `18-24`    = "Over 18",
  `25-34`    = "Over 18",
  `over 34`  = "Over 18",
  `under 10` = "Below 18"
))

stops_piped <- stops %>%                    
  filter(outcome == "Arrest") %>% 
  select(gender, age, ethnic, outcome, legislation) %>% 
  rename(ethnicity = ethnic) %>% 
  drop_na()



download.file(url = "https://github.com/langtonhugh/ESC2019_materials/raw/master/banning_orders.csv", destfile = "original_data/bans-data.csv")

bans <- read_csv(file = "original_data/bans-data.csv")


ggplot(
  # Specify the data
  data = bans,
  # Specify the aesthetics to represent the data
  mapping = aes(x = `League of the Club Supported`, y = `Banning Orders`)) +
  # Specify the geometry to display the aesthetics
  geom_boxplot()



ggplot(data = bans) +
  geom_boxplot(mapping = aes(x = `League of the Club Supported`, y = `Banning Orders`))


crimes <- get_crime_data(years = 2017, type = "core")

dis_con <- crimes %>% 
  filter(offense_type == "disorderly conduct") %>% 
  drop_na(location_category)

ggplot(data = dis_con, mapping = aes(x = city_name)) + # set data and aesthetics
  geom_bar() +                                         # set geom
  labs(x = NULL,                                       # remove x-axis label
       y = "count of crimes",                          # optional labels
       title = "Counts of disorderly conduct",
       subtitle = "United States, January to December 2017",
       caption = "Source: Crime Open Database") +
  coord_flip() +                                       # flip the plot
  theme_bw()         

ggplot(data = dis_con, mapping = aes(x = city_name, fill = location_category)) +
  geom_bar() +
  labs(x = NULL,
       y = "count of crimes",
       title = "Counts of disorderly conduct",
       subtitle = "United States, January to December 2017",
       caption = "Source: Crime Open Database",
       fill = "Location category") +  # new label for the fill aesthetic
  coord_flip() +
  theme_bw()

crimes %>%
  group_by(city_name) %>%
  tally(name = "crime_counts") # We specify the name of the new variable too.

block_counts <- crimes %>% 
  group_by(city_name, census_block) %>% # Group by city and census block
  tally(name = "crime_counts") %>%      # Counts (by city and census block)
  filter(crime_counts <= 20)            # Exclude counts greater than 20

write_csv(block_counts, path = "output_data/block_counts.csv")

ggplot(data = block_counts, mapping = aes(x = crime_counts)) +
  geom_density(fill = "black") +
  facet_wrap(~ city_name) +
  theme(legend.position = "none")  # remove the legend, since it only has one value

p1 <- ggplot(data = block_counts, mapping = aes(x = crime_counts)) +
  geom_density(fill = "black") +
  facet_wrap(~ city_name) +
  theme(legend.position = "none")

ggsave(filename = "output_files/my_plot.jpeg", plot = p1, device = "jpeg")
