library(shiny)

shinyUI(fluidPage(
  titlePanel("Lunch Buddy"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("num", label = "Number of buddies: ", value = 1, min = 1, max = 29),
      br(),
      br(),
      actionButton("find", "Try again")
    ),
    
    mainPanel(
      h4(paste0("Greetings! Look for lunch suggestions on ", Sys.Date(), "?")),
      br(),
      br(),
      htmlOutput("result")
    )
  )
))


