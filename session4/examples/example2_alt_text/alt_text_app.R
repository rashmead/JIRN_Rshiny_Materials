
library(shiny)

myUI = fluidPage(
    
    selectInput(
        inputId = "selected_outcome",
        label = "Choose a Variable to Analyze",
        choices = c("Sepal.Length","Sepal.Width","Petal.Length"),
        selected = "Sepal.Length",
        multiple = FALSE
    ),
    
    plotOutput("plot1"),
    plotOutput("plot2")
)

myServer = function(input, output){
    
    
    alt_text1 = reactive({
        paste0("Alt1 - A plot showing Petal.Width by ", input$selected_outcome)
    })
    
    output$plot1 = renderPlot({
        
        ggplot(iris, aes(y=.data[[input$selected_outcome]], x=Petal.Width)) +
            geom_point()
    }, alt = alt_text1) #note this has to be a reactive if you want but not with ()
    
    
    output$plot2 = renderPlot({
        
        ggplot(iris, aes(y=.data[[input$selected_outcome]], x=Petal.Width)) +
            geom_point() + 
            labs(alt = paste0("Alt2 - A plot showing Petal.Width by ", input$selected_outcome))
    })
    
}

shinyApp(ui = myUI, server = myServer)
