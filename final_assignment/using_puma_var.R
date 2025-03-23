library(stringr)
library(dplyr)
library(here)
library(readr)

#information about PUMAs 
#https://nij.ojp.gov/funding/recidivism-forecasting-challenge#20-0

#pad the strings with 0s on the lefthand side
puma_crosswalk = read_csv(here("final_assignment","puma_crosswalk.csv")) %>%
  mutate(PUMA =  str_pad(PUMA, width = 5, side = "left", pad = "0")) %>%
  rename(data_puma_code = CODE)

georgia_pumas = tigris::pumas(state = "13", year = "2015")

#New variable on the PUMA shapefile named "code" that matches with recidivism data
georgia_pumas = georgia_pumas %>%
  left_join(puma_crosswalk, by = c("PUMACE10" = "PUMA"))

recidivism_data = read_csv(here("data","NIJRecidivismChallenge","NIJ_s_Recidivism_Challenge_Full_Dataset_20250202.csv"))

table(recidivism_data$Residence_PUMA)

georgia_rev_pumas = georgia_pumas %>%
  group_by(data_puma_code) %>%
  summarize(geometry = sf::st_union(geometry))%>%
  ungroup()

table(georgia_rev_pumas$data_puma_code)

##examples
library(leaflet)

#original set of PUMAs
leaflet() %>%
  addPolygons(data = georgia_pumas,
              label = ~PUMACE10) 

#Aggregated PUMAs used in the data
leaflet() %>%
  addPolygons(data = georgia_rev_pumas,
              label = ~paste0("PUMA code ",data_puma_code)) 


