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
        
        if(input$selected_grouping != "no_grouping"){
            group_text = paste0(" by ", input$selected_grouping)
        }else{
            group_text = ""
        }
        
        percent_count_text = ifelse(input$add_percent_column, " percentages", " counts")
        
        out = paste0(input$selected_outcome, percent_count_text, group_text)
       
        return(out)
    })
    
    
    output$output_plot = renderPlot({
        
        input$update_plot
        
        isolate({
        
            if(input$add_percent_column){
                yvar = "percent"
            }else{
                yvar = "count"
            }
            
            if(input$selected_grouping != "no_grouping"){
                p = ggplot(tab_data()) + 
                    aes(x = .data[[input$selected_outcome]], y = .data[[yvar]],
                        fill = .data[[input$selected_grouping]]) +   #aesthetic mapping 
                    geom_bar(position="dodge", stat="identity") + #visualization 
                    theme(axis.text.x = element_text(angle=90, hjust = 1) ) + #change the angle of the tick mark    
                    ggtitle(plot_title())
            }else{    
                p = ggplot(tab_data()) + 
                    aes(x = .data[[input$selected_outcome]], y = .data[[yvar]]) +   #aesthetic mapping 
                    geom_bar(position="dodge", stat="identity") + #visualization 
                    theme(axis.text.x = element_text(angle=90, hjust = 1) ) + #change the angle of the tick mark
                    ggtitle(plot_title())
            }
                
            return(p)
            
        })
    })
    
    output$output_table = renderTable({
        return(tab_data())
    })
    
    
}