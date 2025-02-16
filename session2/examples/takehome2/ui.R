fluidPage(title = "Recidivism Analysis",
          
  selectInput(
      inputId = "selected_outcome",
      label = "Choose a Variable to Analyze",
      choices = c(
                  "Recidivism Within 3years" = "Recidivism_Within_3years", 
                  "Recidivism Arrest Year 1" = "Recidivism_Arrest_Year1",
                  "Recidivism Arrest Year 2" = "Recidivism_Arrest_Year2",
                  "Recidivism Arrest Year 3" = "Recidivism_Arrest_Year3"
      ),
      selected = "Recidivism_Within_3years",
      multiple = FALSE
  ),
  
  selectInput(
      inputId = "selected_grouping",
      label = "Choose a variable to analze the outcome by",
      choices = c("Supervision Risk Score First" = "Supervision_Risk_Score_First",
                  "Race" = "Race",
                  "Education Level" = "Education_Level",
                  "Prison_Years" = "Prison_Years",
                  "Prison_Offense" = "Prison_Offense"
      ),
      selected = "Supervision_Risk_Score_First",
      multiple = FALSE
  ),
  
 
  
  tableOutput("output_table")
)