library(shiny)

shinyUI(fluidPage(
  titlePanel("Lunch Buddy"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("num", label = "Number of buddies: ", value = 1, min = 1, max = 29),
      br(),
      br(),
      actionButton("find", "Try again"),
      actionButton("email", "Email buddies")
    ),
    
    mainPanel(
      htmlOutput("result")
    )
  )
))


