library(dplyr)
library(here)
library(readr)
library(ggplot2)
library(DT)
library(plotly)
library(leaflet)
library(shiny)

user_base = readRDS(here("session5", "examples", "example1_shinyauthr","create_passwords","user_base.rds"))

flordia_arrests1 = read_csv(here("data","FloridaConvictions","FloridaConvictions_00000.csv"))
arrest_data = flordia_arrests1 %>%
    mutate(ARREST_YEAR = as.character(ARREST_YEAR))

# #this loops over all the files and puts them in one dataset
# all_data_files = list.files(here("data","FloridaConvictions"))
# 
# #12811481 rows! 2012-2024
# arrest_data = do.call(bind_rows, lapply(all_data_files, FUN = function(file){
#     data = readr::read_csv(here("data","FloridaConvictions",file))
#     #for some reason it looks like these are characters in some cases and numeric in others
#     data$PROS_AON = as.character(data$PROS_AON) #
#     data$DISP_AON = as.character(data$DISP_AON)
#     return(data)
# }))


fl_counties_geo = tigris::counties(state = "12", year = "2024")

fl_county_pop = read.csv("https://www2.census.gov/programs-surveys/popest/datasets/2020-2023/counties/asrh/cc-est2023-agesex-12.csv")

fl_county_pop_sub = fl_county_pop %>%
    filter(YEAR == 1) %>%
    select(CTYNAME, POPESTIMATE)
    
fl_counties_geo = fl_counties_geo %>% left_join(fl_county_pop_sub, by = c("NAMELSAD"= "CTYNAME"))

outcome_variables = c(
    "Prosecution Offense" = "PROS_OFFENSE", 
    "Prosecution Grouping" = "PROS_GROUPING",
    "Prosecution Degree" = "PROS_DEGREE"
)

grouping_variables = c("No grouping" = "no_grouping",
            "Sex" = "SEX",
            "Race" =  "RACE",
            "Arrest Year" = "ARREST_YEAR"
)

map_outcomes = c("Total Prosecutions" = "total",
                 "1st Degree Prosecutions" = "1st Degree",
                 "2nd Degree Prosecutions" = "2nd Degree",
                 "3rd Degree Prosecutions" = "3rd Degree",
                 "Capital Prosecutions" = "Capital",
                 "Life Prosecutions" = "Life")


source(here("session5", "examples", "example1_shinyauthr","ui_tabs.R"))


