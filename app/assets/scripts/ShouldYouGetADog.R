# -- ShouldYouGetADog.R ------------------------------------#
#                                                           #
# Utility script with some functions to assist              #
# in calculating the Recommendation Score for "Should       #
# You Get A Dog?"                                           #
# ----------------------------------------------------------#


## set variables

    # "Should you get a dog" recommendation score
    Score <- rep(0,3)
    
    # Default Weights
    Elderly <- c(7.38, 15.816, 23.598)
    Child <- c(0.33, 3.486,	6.162)
    DesireMentalHealth <- c(12.28714777, 17.35419784, 22.28094891)
    DesirePhysicalHealth <- c(6.928548586, 8.432225643, 9.846107687)
    HasAllergies <- c(-3.41, -5.81,	-8.32)
    House <- c(8.792, 9.71, 10.542)
    LivesAlone <- c(7.255, 8.548333333, 9.876666667)
    LivesWOthers <- c(2.7525, 3.845, 4.825)
    HasPriorOwnership <- c(2, 2, 2) 
    LowerWillingnessToPay <- c(-19.66, -27.25, -33.97)

# Score updates based on user inputs (from Shiny App Form)  
GenerateScore <- function(userValues) {
  userValues <- isolate(userValues)

  # Q: How old are you? 
    
    #store Shiny input in variable
    AgeInput <- userValues$age
    
    # super elderly
    if (AgeInput >= 80) {
      Score[1:3] <- Score[1:3] + 0
    # elderly
    } else if (AgeInput >= 65) {
      Score[1:3] <- Score[1:3] + Elderly[1:3]
    # adult  
    } else if (AgeInput > 18) {
      Score[1:3] <- Score[1:3] + 0
    # child
    } else {
      Score[1:3] <- Score[1:3] + Child[1:3]
    }
    
  #Q: What is your home like?
    
    #store Shiny input in variable
    HomeInput  <- userValues$homeType
    
    # lives in a house
    if (HomeInput == "house") {
      Score[1:3] <- Score[1:3] +  House[1:3]
    # lives in an apartment
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  #Q: Do you desire Mental/Emotional health benefits from owning a dog?
    
    #store Shiny input in variable
    MentalHealthInput <- userValues$emotionalBen
    
    # desires mental/emotional health benefits
    if (MentalHealthInput) {
      Score[1:3] <- Score[1:3] +  DesireMentalHealth[1:3]
    # does not desire mental/emotional health benefits
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  #Q: Do you desire Physical health benefits from owning a dog?
    
    #store Shiny input in variable
    PhysicalHealthInput<- userValues$physicalBen
    
    # desires physical health benefits
    if (PhysicalHealthInput) {
      Score[1:3] <- Score[1:3] +  DesirePhysicalHealth[1:3]
    # desires not desire physical health benefits
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  #Q: Do you live alone?
    
    #store Shiny input in variable
    LivingWithInput <- userValues$liveAlone
    
    # lives alone
    if (LivingWithInput) {
      Score[1:3] <- Score[1:3] +  LivesAlone[1:3]
    #lives with others
    } else {
      Score[1:3] <- Score[1:3] +  LivesWOthers[1:3]
    }
    
  #Q: Are you or anyone in your household allergic to dogs?
  
    # store Shiny input in variable
    AllergiesInput <- userValues$allergy
    
    # has allergies
    if (AllergiesInput) {
      Score[1:3] <- Score[1:3] +  HasAllergies[1:3]
    # does not have allergies
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  #Q: Have you owned a dog in the past?
    
    # store Shiny input in variable
    PriorOwnershipInput <- userValues$priorOwn 
    
    # has prior dog ownership
    if (PriorOwnershipInput) {
      Score[1:3] <- Score[1:3] +  HasPriorOwnership[1:3]
    # does not have prior dog ownership
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  #Q: The average monthly cost of owning a dog is $171.24 (ranges from $55.47 - $395.69). Would you be able/willing to pay equal to that amount, below that amount, or above that amount for your dog?
    
    # store Shiny input in variable
    ExpensesInput <- userValues$income
    
    # willing/able to pay below monthly average
    if (ExpensesInput == "Less") {
      Score[1:3] <- Score[1:3] +  LowerWillingnessToPay[1:3]
    # willing/able to pay equal or above monthly average
    } else {
      Score[1:3] <- Score[1:3] +  0
    }
    
  ## return Score, so that it can be displayed in Shiny
  return(Score)

}
