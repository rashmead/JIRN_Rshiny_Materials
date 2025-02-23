library(dplyr)
library(here)
library(readr)
library(ggplot2)
library(DT)

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


outcome_variables = c(
    "Prosecution Offense" = "PROS_OFFENSE", 
    "Prosecution Grouping" = "PROS_GROUPING",
    "Prosecution Degree" = "PROS_DEGREE"
)

grouping_variables = c("No grouping" = "no_grouping",
            "Sex" = "SEX",
            "Race" = "RACE",
            "Arrest Year" = "ARREST_YEAR"
)

