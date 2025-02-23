function(input, output){
    
    tab_data = reactive({
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
    
    
    plot_title = reactive({
        
        input$update_button
        
        isolate({
        
            if(input$selected_grouping != "no_grouping"){
                group_text = paste0(" by ", names(grouping_variables)[grouping_variables == input$selected_grouping] )
            }else{
                group_text = ""
            }
            
            percent_count_text = ifelse(input$add_percent_column, " Percentages", " Counts")
            
            out = paste0(names(outcome_variables)[outcome_variables == input$selected_outcome], percent_count_text, group_text)
            
        })
        
        return(out)
    })
    
    
    output$output_plot = renderPlotly({
        
        input$update_button
        
        isolate({
        
            if(input$add_percent_column){
                yvar = "percent"
            }else{
                yvar = "count"
            }
            
            mydata = tab_data()
            
            if(input$selected_grouping != "no_grouping"){
                p = plot_ly(mydata, 
                             x = mydata[[input$selected_outcome]], y = mydata[[yvar]],
                             split = mydata[[input$selected_grouping]], type = "bar")
            }else{    
                p = plot_ly(mydata, 
                            x = mydata[[input$selected_outcome]], y = mydata[[yvar]], type = "bar") 
            }
            
            p = p %>% 
                layout(title = plot_title(),
                       xaxis = list(title = names(outcome_variables)[outcome_variables == input$selected_outcome]),
                       yaxis = list(title = yvar)
                ) 
                
            return(p)
            
        })
    })
    
    output$output_table = renderDT({
        
        input$update_button
        
        isolate({
            
            tab_data_names = c(
                names(outcome_variables)[outcome_variables == input$selected_outcome],
                if(input$selected_grouping != "no_grouping"){ 
                    names(grouping_variables)[grouping_variables == input$selected_grouping]
                },
                "Count",
                if(input$add_percent_column){"Percent"}
            )
            
            table_data = tab_data() %>%
                datatable(rownames = FALSE,
                          caption = plot_title(),
                          colnames = tab_data_names,
                          extensions = c('Buttons'),
                          options = list(
                              scrollX = TRUE,
                              scrollY = '500px',
                              paging = FALSE,
                              dom = 'Bfrtip',
                              buttons = c('colvis','csv', 'excel', 'pdf', 'print')
                          )
                )
            
            return(table_data)
        })
    })
    
    
}