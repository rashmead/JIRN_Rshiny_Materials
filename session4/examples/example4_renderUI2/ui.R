
fluidPage(title = "Iris Data Example",
    
    selectizeInput(
        inputId = "select_variables",
        label = "Select one or two variables",
        choices = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"),
        selected = c("Sepal.Length"),
        multiple = TRUE,
        options = list(maxItems = 2)
    ),
    
    uiOutput("ui_statistic_select"),
    
    checkboxInput(
        "group_by_species",
        label = "Group By Species",
        value = FALSE
    ),

    tableOutput("table")
    

)
    

    


