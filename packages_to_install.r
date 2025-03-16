
packages_to_install = c(
    "shiny",
    "dplyr",
    "ggplot2",
    "plotly",
    "DT",
    "shinyWidgets",
    "shinythemes",
    "htmltools",
    "leaflet",
    "sf",
    "tigris",
    "readr",
    "here",
    "shinydashboard",
    "revealjs",
    "flexdashboard"
)

#to install all of these
lapply(packages_to_install,  install.packages)

