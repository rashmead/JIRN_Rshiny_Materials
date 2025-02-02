function(input, output){
    
    output$text_selections = renderText({
        paste0("You have selected ", input$year,
               " and ", input$selected_outcome
        )
    })
    
    output$output_table = renderTable({
        
        out = arrest_data %>% 
            filter(ARREST_YEAR == input$year) %>%
            group_by( .data[[input$selected_outcome]] ) %>%
            summarize(count = n()) %>%
            arrange(desc(count))
        
        if(input$add_percent_column){
            out = out %>%
                mutate(percent = 100*round(count/sum(count),4))
        }
            
        return(out)
    })
}