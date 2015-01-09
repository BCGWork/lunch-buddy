library(shiny)
buddy <- read.csv("data/member.csv")
numBuddy <- nrow(buddy) - 1

shinyUI(
  fluidPage(
    theme="bootstrap.min.css",
    navbarPage(
      "Lunch Buddy",
      tabPanel(
        "App",
        sidebarLayout(
          sidebarPanel(
            selectInput("user", label="Who are you?", as.character(buddy$nickname)[order(as.character(buddy$nickname))]),
            sliderInput("num", label="Number of buddies:", min=1, max=numBuddy, value=1, step=1),
            br(),
            actionButton("find", "Try again")
          ),
          
          mainPanel(
            tags$body(tags$script(type="text/javascript", src="lb.js")),
            h4(paste0("Greetings! Look for lunch suggestions on ", Sys.Date(), "?")),
            br(),
            br(),
            htmlOutput("result"),
            plotOutput("static_map", height="640px"),
            htmlOutput("email")
          )
        )
      ),
      tabPanel("About")
    )
  )
)

