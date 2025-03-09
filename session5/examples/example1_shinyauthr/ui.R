navbarPage(title = "Florida Arrests",
           theme = shinythemes::shinytheme("cosmo"),
           lang = "en-US",
           id = "navbar",
           
   tabPanel("Login",      
            # add logout button UI
            div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
            # add login panel UI function
            shinyauthr::loginUI(id = "login")
   )
   

)