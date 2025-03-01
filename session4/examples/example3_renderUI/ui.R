
fluidPage(title = "Render UI Example",
          selectInput(
              inputId = "select_static_option",
              label = "make a selection",
              choices = c("first choice", "second choice"),
              selected = "first choice",
              multiple = FALSE
          ),
          uiOutput("dynamic_select"),
          textOutput("letter_selction")
)