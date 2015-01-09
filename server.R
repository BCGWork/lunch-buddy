library(shiny)
library(rjson)
library(ggmap)

buddy <- read.csv("data/member.csv")
buddy$id <- 1:nrow(buddy)
kNumBuddy <- nrow(buddy) - 1

office <- "53 State Street Boston MA"
office.gc <- geocode(office)

shinyServer(function(input, output) {
  data.object <- reactive({
    input$find
    isolate({
      place.json <- fromJSON(file = "data/restaurant_data.txt")
      place <- lapply(place.json, function(x) {data.frame("name"=x$name, "address"=x$address, "lat"=x$lat, "long"=x$long)})
      restaurant <- do.call(rbind, place)
      kNumPlace <- nrow(restaurant)
      
      buddy.pool <- subset(buddy$id, buddy$nickname!=input$user)
      kBuddyInd <- sample(buddy.pool, input$num)
      kRestInd <- sample(1:kNumPlace, 1)
      buddy.list <- as.character(buddy[kBuddyInd, ]$nickname)[order(as.character(buddy[kBuddyInd, ]$nickname))]
      email.list <- paste(paste0(buddy[kBuddyInd, ]$lastname, ".", buddy[kBuddyInd, ]$firstname, "@bcg.com"), collapse = ", ")
      return(list("kRestInd" = kRestInd, "buddy.list" = buddy.list, "email.list" = email.list, "restaurant" = restaurant))
    })
  })
  
  output$result <- renderPrint({
    data <- data.object()
    kRestInd <- data$kRestInd
    buddy.list <- data$buddy.list
    restaurant <- data$restaurant
    
    cat(
      paste0(
        "How about going to <a href=https://www.google.com/maps/dir/The+Boston+Consulting+Group,+53+State+St,+Boston,+MA+02109-2802,+United+States/",
        gsub(" ", "+", paste(restaurant$name[kRestInd], as.character(restaurant$address[kRestInd]))),
        " target='_blank'>",
        restaurant$name[kRestInd],
        "</a> with ",
        paste(buddy.list, collapse = ", "),
        "?"
      )
    )
  })
  
  output$static_map <- renderPlot({
    data <- data.object()
    kRestInd <- data$kRestInd
    restaurant <- data$restaurant
    
    restaurant.gc <- c(restaurant$long[kRestInd], restaurant$lat[kRestInd])
    gc.df <- data.frame(rbind(office.gc, restaurant.gc))
    gc.df$type <- c("Office", as.character(restaurant$name[kRestInd]))
    ggmap(get_googlemap(office, zoom=16, marker=gc.df[, 1:2])) +
      geom_text(aes(x=lon, y=lat, label=type), data=gc.df, colour="red", vjust=1)
  }, width=640)
  
  output$email <- renderPrint({
    data <- data.object()
    kRestInd <- data$kRestInd
    email.list <- data$email.list
    restaurant <- data$restaurant
    
    cat(paste0("<a href='mailto:", email.list, "?Subject=You are my lunch buddy today!&body=Hey! Wanna grab lunch at ", gsub("'", "", as.character(restaurant$name[kRestInd])), " with me?'>Email buddies?</a>"))
    cat("<br/>")
    cat("<br/>")
    cat("Don't feel like hanging out with them today? Click <b>Try Again</b> to get the cooler kids!")
  })
})



