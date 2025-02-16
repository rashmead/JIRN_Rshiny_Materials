
header = dashboardHeader(
    title = "Florida Arrests"
)

sidebar = dashboardSidebar(
    dateRangeInput(
        "daterange",
        "Select a Date Range Input for the Arrest Date",
        start = "2014-01-01", #initial value
        end = "2018-12-31", #initial value
        min = "2014-01-01", #minimum allowed date
        max = "2018-12-31", #maximum allowed date
        format = "yyyy-mm-dd"
    ),
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
    ),
    selectInput(
        inputId = "selected_grouping",
        label = "(Optional) Choose a variable to group the anlaysis by",
        choices = c("No grouping" = "no_grouping",
                    "Sex" = "SEX",
                    "Race" = "RACE"
        ),
        selected = "no_grouping",
        multiple = FALSE
    ),
    checkboxInput(
        inputId = "add_percent_column",
        label ="Calculate Percent",
        value = FALSE 
    ),
    checkboxInput(
        inputId = "remove_missing",
        label ="Remove Missing Values from Calculations",
        value = FALSE 
    )
)

body = dashboardBody(
        tableOutput("output_table")
)

dashboardPage(
    header,
    sidebar,
    body
)

