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
      choices = c("SEX",
                  "RACE",
                  "PROS_OFFENSE", 
                  "PROS_GROUPING",
                  "PROS_DEGREE"
      ),
      selected = "PROS_OFFENSE",
      multiple = FALSE
  ),
  
  textOutput("text_selections"),
  tableOutput("output_table")
)