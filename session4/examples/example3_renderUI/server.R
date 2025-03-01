function(input, output){
    output$dynamic_select = renderUI({
        
        if(input$select_static_option == "first choice"){
            choices = c("a","b","c")
        }else{
            choices = c("x","y","z")
        }
        
        selectInput(
            inputId = "dynamic_selection",
            label = "select a letter",
            choices = choices,
            selected = choices[1],
            multiple = FALSE
        )
    })
    
    output$letter_selction = renderText({
        paste0("You selected ", input$dynamic_selection)
    })
}