
# Data handling to create example crime data set for ESC 2019

library(tidyverse)
library(lubridate)

df <- read_csv("C:/Users/PhD/OneDrive - MMU/Teaching/cRim/data/gmp_data/2018-12/2018-12-greater-manchester-stop-and-search.csv")

# Make vars shorter

names(df)

names(df) <- c("type","date","operation","operation2","latitude","longitude","gender",
               "age","ethnic","officer_ethnic","legislation","objectofsearch","outcome",
               "outcome_link","clothing_rm")

df <- df %>%
  separate(col = date, into = c("day","time"), sep = " ",remove = F) %>% 
  arrange(ethnic)

write_csv(df, "C:/Users/PhD/OneDrive - MMU/Teaching/cRim/data/gmp_data/2018-12/2018-12-greater-manchester-stop-and-search_edit.csv")

download.file(url = "https://github.com/langtonhugh/ESC2019/raw/master/2018-12-greater-manchester-stop-and-search_edit.csv",
              destfile = "C:/Users/PhD/OneDrive - MMU/Teaching/cRim/data/gmp_data/2018-12/2018-12-greater-manchester-stop-and-search_edit.csv")


df <- read_csv("https://github.com/langtonhugh/ESC2019/raw/master/2018-12-greater-manchester-stop-and-search_edit.csv")

glimpse(df)
