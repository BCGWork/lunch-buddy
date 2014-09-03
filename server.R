library(shiny)
library(rjson)

buddy <- read.csv("data/member.csv")
placeJSON <- fromJSON(file = "data/restaurant_data.txt")
place <- lapply(placeJSON, function(x) {data.frame("name"=x$name, "address"=x$address)})
restaurant <- do.call(rbind, place)
numBuddy <- nrow(buddy)
numPlace <- nrow(restaurant)

shinyServer(function(input, output) {
  output$result <- renderPrint({    
    input$find
    budInd <- sample(1:numBuddy, input$num)
    resInd <- sample(1:20, 1)
    buddyList <- as.character(buddy[budInd,]$nickname)
    mailList <- paste(paste0(buddy[budInd,]$lastname, ".", buddy[budInd,]$firstname, "@bcg.com"), collapse = ",")
    
    cat(paste0("How about going to <a href=http://maps.google.com/?q=", gsub(" ", "+", paste(restaurant$name[resInd], as.character(restaurant$address[resInd]))), " target='_blank'>", restaurant$name[resInd], "</a> with ", paste(buddyList, collapse = ", "), "?"))
    cat("<br/>")
    cat("<br/>")
    cat(paste0("<a href='mailto:", mailList, "?Subject=You are my lunch buddy today!&body=Hey! Wanna grab lunch at ", gsub("'", "", as.character(restaurant$name[resInd])), " with me?'>Email buddies?</a>"))
    cat("<br/>")
    cat("<br/>")
    cat("Don't feel like hanging out with them today? Click <b>Try Again</b> to get the cooler kids!")
  })
})



