function(input, output){

    output$table = renderTable({
        
        #req(length(input$select_variables)>=1)
    
        var1 = input$select_variables[1]
        
        if(length(input$select_variables)==2){
            var2 = input$select_variables[2]
        }
        
        if(input$group_by_species){
            data = data %>% group_by(Species)
        }
        
        if(input$summary_function == "mean"){
            out = data %>% summarize(mean = mean(.data[[var1]]))
        }else if(input$summary_function == "median"){
            out = data %>% summarize(median = median(.data[[var1]]))
        }else if(input$summary_function == "correlation"){
            #req(var2) 
            out = data %>% summarize(correlation = cor(.data[[var1]], .data[[var2]]))
        }
        
    })

    output$ui_statistic_select = renderUI({
        
        #req(length(input$select_variables)>=1)
        
        if(length(input$select_variables) == 1){
            stat_choices = c("mean", "median")
        }else if(length(input$select_variables) == 2){
            stat_choices = c("correlation")
        }
        
        selectInput(
            "summary_function",
            label = "Select a Summary Function",
            choices = stat_choices,
            selected = NULL,
            multiple = FALSE
        )
    })
    
 
}