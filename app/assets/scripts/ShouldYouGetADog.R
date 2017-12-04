# -- ShouldYouGetADog.R ------------------------------------#
#                                                           #
# Utility script with some functions to assist              #
# in calculating the Recommendation Score for "Should       #
# You Get A Dog?"                                           #
# ----------------------------------------------------------#


## set variables

    # "Should you get a dog" recommendation score
    Score <- 0
    
    # Default Weights
    Elderly <- 15.816
    Child <- 3.486
    DesireMentalHealth <- 17.35419784
    DesirePhysicalHealth <- 7.229100643
    HasAllergies <- -5.81
    House <- 9.71
    LivesAlone <- 5.34
    LivesWOthers <- 3.845
    HasPriorOwnership <- 2 
    LowerWillingnessToPay <- -27.25

# Score updates based on user inputs (from Shiny App Form)  
GenerateScore <- function(userValues) {
  userValues <- isolate(userValues)

  # Q: How old are you? 
    
    #store Shiny input in variable
    AgeInput <- userValues$age
    
    # super elderly
    if (AgeInput >= 80) {
      Score <- Score + 0
    # elderly
    } else if (AgeInput >= 65) {
      Score <- Score + Elderly
    # adult  
    } else if (AgeInput > 18) {
      Score <- Score + 0
    # child
    } else {
      Score <- Score + Child
    }
    
  #Q: What is your home like?
    
    #store Shiny input in variable
    HomeInput  <- userValues$homeType
    
    # lives in a house
    if (HomeInput == "house") {
      Score <- Score +  House
    # lives in an apartment
    } else {
      Score <- Score +  0
    }
    
  #Q: Do you desire Mental/Emotional health benefits from owning a dog?
    
    #store Shiny input in variable
    MentalHealthInput <- userValues$emotionalBen
    
    # desires mental/emotional health benefits
    if (MentalHealthInput) {
      Score <- Score +  DesireMentalHealth
    # does not desire mental/emotional health benefits
    } else {
      Score <- Score +  0
    }
    
  #Q: Do you desire Physical health benefits from owning a dog?
    
    #store Shiny input in variable
    PhysicalHealthInput<- userValues$physicalBen
    
    # desires physical health benefits
    if (PhysicalHealthInput) {
      Score <- Score +  DesirePhysicalHealth
    # desires not desire physical health benefits
    } else {
      Score <- Score +  0
    }
    
  #Q: Do you live alone?
    
    #store Shiny input in variable
    LivingWithInput <- userValues$liveAlone
    
    # lives alone
    if (LivingWithInput) {
      Score <- Score +  LivesAlone 
    #lives with others
    } else {
      Score <- Score +  LivesWOthers
    }
    
  #Q: Are you or anyone in your household allergic to dogs?
  
    # store Shiny input in variable
    AllergiesInput <- userValues$allergy
    
    # has allergies
    if (AllergiesInput) {
      Score <- Score +  HasAllergies
    # does not have allergies
    } else {
      Score <- Score +  0
    }
    
  #Q: Have you owned a dog in the past?
    
    # store Shiny input in variable
    PriorOwnershipInput <- userValues$priorOwn 
    
    # has prior dog ownership
    if (PriorOwnershipInput) {
      Score <- Score +  HasPriorOwnership
    # does not have prior dog ownership
    } else {
      Score <- Score +  0
    }
    
  #Q: The average monthly cost of owning a dog is $171.24 (ranges from $55.47 - $395.69). Would you be able/willing to pay equal to that amount, below that amount, or above that amount for your dog?
    
    # store Shiny input in variable
    ExpensesInput <- userValues$income
    
    # willing/able to pay below monthly average
    if (ExpensesInput == "Less") {
      Score <- Score +  LowerWillingnessToPay 
    # willing/able to pay equal or above monthly average
    } else {
      Score <- Score +  0
    }
    
  ## return Score, so that it can be displayed in Shiny
  return(Score)

}
