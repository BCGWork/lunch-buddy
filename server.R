library(shiny)

buddy <- read.csv("data/member.csv")
place <- read.csv("data/restaurant.csv")
numBuddy <- nrow(buddy)
numPlace <- nrow(place)

shinyServer(function(input, output) {
  output$result <- renderPrint({
    message <- reactive({
      paste0("Your lunch buddy for ", Sys.Date(), ":")
    })
    
    input$find
    buddyList <- as.character(buddy[sample(1:numBuddy, input$num),]$nickname)
    cat(message())
    cat(paste("\n", buddyList, collapse = ", "))
  })
})



