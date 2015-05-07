library(shiny)
library(rjson)
library(ggmap)

map_key <- readLines("data/google_map_embed_api_key.txt")

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
      place <- lapply(
        place.json,
        function(x) {
          data.frame(
            "name"=x$name,
            "address"=x$address,
            "lat"=x$lat,
            "long"=x$long,
            "url"=x$url,
            "rating"=x$rating
          )
        }
      )
      restaurant <- do.call(rbind, place)
      kNumPlace <- nrow(restaurant)
      
      buddy.pool <- subset(buddy$id, buddy$nickname!=input$user)
      kBuddyInd <- sample(buddy.pool, input$num)
      kRestInd <- sample(1:kNumPlace, 1)
      buddy.list <- as.character(buddy[kBuddyInd, ]$nickname)[order(as.character(buddy[kBuddyInd, ]$nickname))]
      email.list <- paste0(as.character(buddy[kBuddyInd, ]$email), collapse="; ")
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
        "How about going to <a href=",
        restaurant$url[kRestInd],
        " target='_blank'>",
        restaurant$name[kRestInd],
        "</a> with ",
        paste(buddy.list, collapse = ", "),
        "?"
      ),
      "<br />",
      paste0(
        "<img src=",
        restaurant$rating[kRestInd],
        " />"
      )
    )
  })
  
  output$direction <- renderPrint({
    data <- data.object()
    kRestInd <- data$kRestInd
    buddy.list <- data$buddy.list
    restaurant <- data$restaurant
    
    map_url <- paste0("https://www.google.com/maps/embed/v1/directions?key=", map_key)
    origin <- "origin=The+Boston+Consulting+Group,+53+State+St,+Boston,+MA+02109-2802,+United+States"
    destination <- gsub(" ", "+", paste0("destination=", restaurant$name[kRestInd], ",", as.character(restaurant$address[kRestInd])))
    mode <- "mode=walking"
    zoom <- "zoom=17"
    iframe_map <- tags$iframe(width=800, height=600, src=paste(map_url, origin, destination, mode, zoom, sep="&"))
    iframe_map
  })
  
  output$email <- renderPrint({
    data <- data.object()
    kRestInd <- data$kRestInd
    email.list <- data$email.list
    restaurant <- data$restaurant
    
    cat(
      paste0(
        "<a href='mailto:",
        email.list,
        "?Subject=You are my lunch buddy today!&body=Hey! Wanna grab lunch at ",
        gsub("'", "", as.character(restaurant$name[kRestInd])),
        " with me?'>Email Buddies Now!</a>"
      )
    )
  })
})



