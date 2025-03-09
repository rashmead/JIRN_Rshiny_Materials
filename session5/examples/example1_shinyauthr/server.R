function(input, output){
    
    credentials <- shinyauthr::loginServer(
        id = "login",
        data = user_base,
        user_col = user,
        pwd_col = password,
        sodium_hashed = TRUE,
        log_out = reactive(logout_init())
    )
    
    # call the logout module with reactive trigger to hide/show
    logout_init <- shinyauthr::logoutServer(
        id = "logout",
        active = reactive(credentials()$user_auth)
    )
    
    observeEvent(credentials()$user_auth, {
        

        # if user logs in successfully
        if(credentials()$user_auth) {  
            
            removeTab("navbar", "Login")
            
            appendTab("navbar", welcome_tab, select = TRUE)
            appendTab("navbar", data_analysis_tab)
            appendTab("navbar", map_tab)
            
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
            
            output$map_var_level_selection = renderUI({
                
                #get the levels of the selected variable
                var_level = arrest_data %>% 
                    filter(ARREST_DATE >= input$daterange_map[1] & ARREST_DATE <= input$daterange_map[2]) %>%
                    distinct(.data[[input$selected_outcome_map]]) %>%
                    arrange()
                
                selectInput(
                    inputId = "selected_outcome_level_map",
                    label = "Choose a Level Within the Variable to Map",
                    choices = var_level,
                    selected = var_level[1],
                    multiple = FALSE
                )
            })
            
            map_data = reactive({
                
                all_outcomes = arrest_data %>% 
                    filter(ARREST_DATE >= input$daterange_map[1] & ARREST_DATE <= input$daterange_map[2]) %>%
                    group_by(COUNTY) %>%
                    summarize(count_var = sum(.data[[input$selected_outcome_map]] %in% input$selected_outcome_level_map,na.rm = TRUE))
                
                out  = fl_counties_geo %>%
                    left_join(all_outcomes, by = c(NAMELSAD = "COUNTY")) %>%
                    mutate("count_var_rate_per_10k"= count_var / (POPESTIMATE/10000))
                
                return(out)
            })
            
            
            output$output_map = renderLeaflet({
                
                req(input$selected_outcome_level_map)  
                input$update_button_map
                
                isolate({    
                    
                    std_option_var_text = ifelse(input$stand_map_pop, "_rate_per_10k", "") 
                    select_var_name = paste0("count_var",std_option_var_text)
                    
                    std_legend_var_text = ifelse(input$stand_map_pop, "<br>Per 10k Persons", "") 
                    legend_title = paste0( input$selected_outcome_level_map, std_legend_var_text)
                    
                    colors_for_palette = c("#EBF6FF","#6BAED6", "#08306B")
                    cont_pal = colorNumeric(colors_for_palette, domain = map_data()[[select_var_name]], na.color = "#f1f1e0")
                    
                    map_continous_scale = leaflet() %>%
                        addProviderTiles(providers$Esri.WorldGrayCanvas) %>% #this is a more plain tile layer
                        addPolygons(data =  map_data(),
                                    color = "black", #controls the color of the shape boundaries
                                    weight = 2, #conrtrols the thickness of the shape boundaries
                                    fillOpacity = 1, #controls the opacity of the fill color
                                    fillColor = cont_pal(map_data()[[select_var_name]]),
                                    label = ~NAMELSAD) %>% #label gives the tooltip/hover label
                        addLegend("bottomright",
                                  pal = cont_pal,
                                  title = legend_title,
                                  values = map_data()[[select_var_name]],
                                  na.label = paste("No Estimate Available"),
                                  opacity = 1)      
                })
            })
        }
    })
    
    
 
                      
}