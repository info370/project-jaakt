
# "SHOULD YOU GET A DOG?" function

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

# Score updated based on user inputs (from Shiny App Questionaire)  

GenerateScore <- function(userValues) {

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
    if (HomeInput == "House") {
      Score <- Score +  House
      # lives in an apartment
    } else {
      Score <- Score +  0
    }
    
    #Q: Do you desire Mental/Emotional health benefits from owning a dog?
    
    #store Shiny input in variable
    MentalHealthInput <- userValues$emotionalBen
    
    if (MentalHealthInput == "Yes") {
      Score <- Score +  DesireMentalHealth
    } else {
      Score <- Score +  0
    }
    
    #Q: Do you desire Physical health benefits from owning a dog?
    
    #store Shiny input in variable
    PhysicalHealthInput<- userValues$physicalBen
    
    if (PhysicalHealthInput == "Yes") {
      Score <- Score +  DesirePhysicalHealth
    } else {
      Score <- Score +  0
    }
    
    #Q: Do you live alone?
    
    #store Shiny input in variable
    LivingWithInput <- [returnedInput] #??????????
    
    # lives alone
    if (LivingWithInput == "Yes") {
      Score <- Score +  LivesAlone 
      #lives with others
    } else {
      Score <- Score +  LivesWOthers
    }
    
    #Q: Are you or anyone in your household allergic to dogs?
    
    # store Shiny input in variable
    AllergiesInput <- userValues$allergy
    
    # has allergies
    if (AllergiesInput == "Yes") {
      Score <- Score +  Allergies
      # does not have allergies
    } else {
      Score <- Score +  0
    }
    
    #Q: Have you owned a dog in the past?
    
    # store Shiny input in variable
    PriorOwnershipInput <- userValues$priorOwn 
    
    # has prior dog ownership
    if (PriorOwnershipInput == "Yes") {
      Score <- Score +  HasPriorOwnership
      # does not have prior dog ownership
    } else {
      UserScore <- UserScore +  0
    }
    
    #Q: The average monthly cost of owning a dog is $171.24 (ranges from $55.47 - $395.69). Would you be able/willing to pay equal to that amount, below that amount or above that amount for your dog?
    
    # store Shiny input in variable
    ExpensesInput <- userValues$income
    
    # willing/able to pay below monthly average
    if (ExpensesInput == "Below") {
      Score <- Score +  LowerWillingnessToPay 
      # willing/able to pay equal or above monthly average
    } else {
      Score <- Score +  0
    }
    
    ## print the score to Shiny ???
    print(Score)

}
