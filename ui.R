library(shiny)
buddy <- read.csv("data/member.csv")
numBuddy <- nrow(buddy) - 1

shinyUI(fluidPage(
  titlePanel("Lunch Buddy"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("user", label="Who are you?", as.character(buddy$nickname)[order(as.character(buddy$nickname))]),
      sliderInput("num", label="Number of buddies:", min=1, max=numBuddy, value=1, step=1),
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


