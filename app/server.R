
# -- server.R ----------------------------------------------#
#                                                           #
# Script that is the backbone of the shiny application,     #
# It links to index.html in order to render UI components   #
# and return information to be displayed on the website     #
#                                                           #
# ----------------------------------------------------------#

# Akash's Working Directory
# setwd("~/School/INFO370/project-jaakt/app/")
# Ari's Working Directory
# setwd("~/Desktop/school/info370/project-jaakt/app/")
# Jill's Working Directory
#setwd("/Users/jillianhonrade/project-jaakt/app/")
# setwd("/Users/jillianhonrade/project-jaakt/app/")


library(shiny)
suppressPackageStartupMessages(library(dplyr))
library(shinyWidgets)
source("./assets/scripts/BreedSelectionHelpers.R")
source("./assets/scripts/ShouldYouGetADog.R")

# Define server logic that recieves input and modifies an output
shinyServer(function(input, output) {
  # -- DATA HANDLING -------------------------------------------------------------------------------------
  
  # -- FORM HANDLING ----------------------------------------------------------------------------------
  userValues <- reactiveValues()
  breedNames <- reactiveValues()
  
  pictureSize <- c(159,100)
  
  # -- OUTPUT RENDERING ----------------------------------------------------------------------------------
  output$breeds <- renderPrint({
    if (input$age == "") {
      userValues$age <- 0
    } else{
      userValues$age <- as.numeric(input$age) 
    }
    userValues$priorOwn <- as.numeric(input$priorOwn)
    userValues$activeLvl <- input$activeLvl
    userValues$income <- input$income
    userValues$homeType <- input$homeType
    userValues$liveAlone <- as.numeric(input$liveAlone)
    userValues$children <- as.numeric(input$children)
    userValues$currDog <- as.numeric(input$currDog)
    userValues$allergy <- as.numeric(input$allergy)
    userValues$hotScale <- input$hotScale
    userValues$coldScale <- input$coldScale
    userValues$physicalBen <- as.numeric(input$physicalBen)
    userValues$emotionalBen <- as.numeric(input$emotionalBen)
    userValues$noiseTol <- input$noiseTol
    
    selectedBreeds <- GetBreeds(userValues, 3)
    
    breedNames$top <- selectedBreeds[,"Top"]
    breedNames$bottom <- selectedBreeds[,"Bottom"]
  
    # cat("Top 3 Breeds: \n")
    # cat(paste(selectedBreeds[,"Top"], collapse=", "))
    # 
    # cat("\nBottom 3 Breeds: \n")
    # cat(paste(selectedBreeds[,"Bottom"], collapse=", "))
    
    # cat(paste0("\nAge: ", userValues$age,"\n"))
    # cat(paste0("Prior Own: ", input$priorOwn,"\n"))
    # cat(paste0("Activity Level: ", input$activeLvl,"\n"))
    # cat(paste0("Income: ", input$income,"\n"))
    # cat(paste0("Home Type: ", input$homeType,"\n"))
    # cat(paste0("Children: ", input$children,"\n"))
    # cat(paste0("Current Dog: ", input$currDog,"\n"))
    # cat(paste0("Allergy: ", input$allergy,"\n"))
    # cat(paste0("Hot Scale: ", input$hotScale,"\n"))
    # cat(paste0("Cold Scale: ", input$coldScale,"\n"))
    # cat(paste0("Physical Benefits: ", input$physicalBen,"\n"))
    # cat(paste0("Emotional Benefits: ", input$emotionalBen,"\n"))
    # cat(paste0("Noise Tolerance: ", input$noiseTol,"\n"))
    
    Score <- GenerateScore(userValues)
    
    cat("\nShould you get a dog:")
    if (Score >= 0) {
      cat(paste0(" You should get a dog!\n"))
    } else {
      cat(paste0(" Maybe getting a dog isn't the best choice for you right now.\n"))
    }
    cat(paste0("Recommendation Score * : ", Score,"\n"))
  })
  
  output$note <- renderPrint({
    cat(paste0("\n* This score is based on our analysis of benefits of dog ownership and factors of dog-compatibility. While this score is supported by data, one's experience with dog ownership is subjective and may differ. Our suggested breeds may not actually be the best breeds for you, and breeds we warn against may actually work well for you, depending on many other personal factors."))
  })
  
  output$imageT1 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$top[1], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$t1Name <- renderPrint({
    cat(paste0("1. ", breedNames$top[1]))
  })
  
  output$imageT2 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$top[2], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$t2Name <- renderPrint({
    cat(paste0("2. ", breedNames$top[2]))
  })
  
  output$imageT3 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$top[3], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$t3Name <- renderPrint({
    cat(paste0("3. ", breedNames$top[3]))
  })
  
  output$imageB1 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$bottom[1], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$b1Name <- renderPrint({
    cat(paste0("1. ", breedNames$bottom[1]))
  })
  
  output$imageB2 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$bottom[2], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$b2Name <- renderPrint({
    cat(paste0("2. ", breedNames$bottom[2]))
  })
  
  output$imageB3 <- renderImage({
    filename <- normalizePath(file.path('./assets/images', paste0(breedNames$bottom[3], '.png')))
    
    list(src = filename,
         width = pictureSize[1],
         height = pictureSize[2],
         alt = "")
  }, deleteFile = FALSE)
  
  output$b3Name <- renderPrint({
    cat(paste0("3. ", breedNames$bottom[3]))
  })
  
})
