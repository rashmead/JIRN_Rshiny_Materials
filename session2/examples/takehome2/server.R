function(input, output){
    
    
    output$output_table = renderTable({
        
        out = recidivism_data %>% 
            group_by( .data[[input$selected_grouping]]) %>%
            summarize("Outcome %" =  round(100*mean(.data[[input$selected_outcome]]), 2),
                      "Count" = n())
            
        return(out)
    })
}