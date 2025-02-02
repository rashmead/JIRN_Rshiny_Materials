fluidPage(title = "Florida Arrests",
          
  selectInput(
      inputId = "year",
      label = "Select a year",
      choices = c("2014","2015","2016","2017","2018"),
      multiple = FALSE
  ),
  
  selectInput(
      inputId = "selected_outcome",
      label = "Choose a Variable to Analyze",
      choices = c("Sex" = "SEX",
                  "Race" = "RACE",
                  "Prosecution Offense" = "PROS_OFFENSE", 
                  "Prosecution Grouping" = "PROS_GROUPING",
                  "Prosecution Degree" = "PROS_DEGREE"
      ),
      selected = "PROS_OFFENSE",
      multiple = FALSE
  ),
  
  checkboxInput(
      inputId = "add_percent_column",
      label ="Calculate Percent",
      value = FALSE 
  ),
  
  textOutput("text_selections"),
  tableOutput("output_table")
)