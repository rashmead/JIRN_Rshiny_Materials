
welcome_tab = tabPanel("Welcome",
         tags$h1("Welcome to the Florida Arrests Analysis Dashboard"),
         "The data in this dashboard comes from ",
         tags$a("the Florida Department of Law Enforcement Website", target = "_blank",
                style = "color: #0000C2;",
                href = "https://www.fdle.state.fl.us/CJAB/FSAC/CJDT-Presentation.aspx")
)

data_analysis_tab = tabPanel("Data Analysis",
  fluidRow(
    sidebarPanel(
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
            choices = outcome_variables,
            selected = outcome_variables[3],
            multiple = FALSE
        ),
        selectInput(
            inputId = "selected_grouping",
            label = "(Optional) Choose a variable to group the anlaysis by",
            choices = grouping_variables,
            selected = "no_grouping",
            multiple = FALSE
        ),
        checkboxInput(
            inputId = "add_percent_column",
            label ="Show Percent (within group)",
            value = FALSE
        ),
        checkboxInput(
            inputId = "remove_missing",
            label ="Remove Missing Values from Calculations",
            value = FALSE
        ),
        actionButton(
            inputId = "update_button",
            label = "Update the Plot and Table"
        )
    ),
    mainPanel(
       plotlyOutput("output_plot")
    )
  ), #end fluidrow
  fluidRow(
      column(12, align="center",
             DTOutput("output_table")
      )
  )
)#end tabPanel

map_tab = tabPanel("Map",
         fluidRow(
             sidebarPanel(
                 dateRangeInput(
                     inputId = "daterange_map",
                     label = "Select a Date Range Input for the Arrest Date",
                     start = "2014-01-01", #initial value
                     end = "2018-12-31", #initial value
                     min = "2014-01-01", #minimum allowed date
                     max = "2018-12-31", #maximum allowed date
                     format = "yyyy-mm-dd"
                 ),
                 selectInput(
                     inputId = "selected_outcome_map",
                     label = "Choose a Variable to Map",
                     choices = outcome_variables,
                     selected = outcome_variables[1],
                     multiple = FALSE
                 ),

                 uiOutput("map_var_level_selection"),

                 checkboxInput(
                     inputId = "stand_map_pop",
                     label ="Standardize by county population",
                     value = TRUE
                 ),
                 actionButton(
                     inputId = "update_button_map",
                     label = "Update the Map"
                 )
             ),
             mainPanel(
                 leafletOutput("output_map")
             )
         ) #end fluidrow
)#end tabPanel