fluidPage(title = "Florida Arrests",
  fluidRow(
      column(4,
          dateRangeInput(
              "daterange",
              "Select a Date Range Input for the Arrest Date",
              start = "2014-01-01", #initial value
              end = "2018-12-31", #initial value
              min = "2014-01-01", #minimum allowed date
              max = "2018-12-31", #maximum allowed date
              format = "yyyy-mm-dd"
          )
      ), #end column
      column(4,
          selectInput(
              inputId = "selected_outcome",
              label = "Choose a Variable to Analyze",
              choices = c(
                          "Prosecution Offense" = "PROS_OFFENSE", 
                          "Prosecution Grouping" = "PROS_GROUPING",
                          "Prosecution Degree" = "PROS_DEGREE"
              ),
              selected = "PROS_OFFENSE",
              multiple = FALSE
          )
      ), #end column
    column(4,
      selectInput(
          inputId = "selected_grouping",
          label = "(Optional) Choose a variable to group the anlaysis by",
          choices = c("No grouping" = "no_grouping",
                      "Sex" = "SEX",
                      "Race" = "RACE"
          ),
          selected = "no_grouping",
          multiple = FALSE
      )
    ) #end column
  ), #end row
  fluidRow(
      column(6,
          checkboxInput(
              inputId = "add_percent_column",
              label ="Calculate Percent",
              value = FALSE 
          )
      ), #end column
      column(6,
          checkboxInput(
              inputId = "remove_missing",
              label ="Remove Missing Values from Calculations",
              value = FALSE 
          )
      )
  ), #end row
  fluidRow(
    column(12, offset = 1,
        textOutput("text_selections")
    )
  ),
  fluidRow(
    column(12, offset = 4,
        tableOutput("output_table")
    )
  )
)