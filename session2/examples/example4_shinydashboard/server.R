function(input, output){
    
    output$text_selections = renderText({
        paste0("You have selected ", input$year,
               " and ", input$selected_outcome
        )
    })
    
    output$output_table = renderTable({
        
        if(input$selected_grouping != "no_grouping"){
        
            out = arrest_data %>% 
                filter(ARREST_DATE >= input$daterange[1] & ARREST_DATE <= input$daterange[2]) %>%
                group_by( .data[[input$selected_outcome]], .data[[input$selected_grouping]] ) %>%
                summarize(count = n()) 
        }else{
            
            out = arrest_data %>% 
                filter(ARREST_DATE >= input$daterange[1] & ARREST_DATE <= input$daterange[2]) %>%
                group_by( .data[[input$selected_outcome]] ) %>%
                summarize(count = n()) %>%
                arrange(desc(count))
        }
        
        if(input$remove_missing){

            out = out %>% filter(! is.na(.data[[input$selected_outcome]]))
        }
        
        if(input$add_percent_column){
            
            if(input$selected_grouping != "no_grouping"){
                
                out = out %>%
                    group_by(.data[[input$selected_grouping]]) %>%
                    mutate(percent = 100*round(count/sum(count),4))
            
            }else{
                out = out %>%
                    mutate(percent = 100*round(count/sum(count),4))
            }

        }
            
        return(out)
    })
}