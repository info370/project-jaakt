# -- BreedSelectionHelper.R --------------------------------#
#                                                           #
# Utility script with some functions to assist              #
# in filtering breed with given responses.                  #
#                                                           #
# ----------------------------------------------------------#

# setwd("~/School/INFO370/project-jaakt/app/")
# setwd("~/Desktop/school/info370/project-jaakt/app/")

# Sets number of features/columns
NUM_OF_FEATURES <- 26

# Retrieves information that we scraped from dogtime.com
breedDF <- read.csv(file = "./assets/data/Breed_Information_DogTime.csv", stringsAsFactors = FALSE)

# Removing both name and lifespan since they are not ratings, but the order of the values
# will remain so it can match up to breed.
labelCols <- which(colnames(breedDF) %in% c("Name", "Life.Span"))
breedMatrix <- data.matrix(breedDF[,-labelCols])

# Gets the breed names in order
breedNames <- breedDF[1]

# Function: GenerateWeightVector 
# ----------------------------
# Takes a list of values from the user input and generates 
# a weight vector (size 26x1)
# 
# userValues: a list of values from the form filled by user
#
# returns: a vector of weights for each column in the breed dataset
GenerateWeightVector <- function(userValues) {
  cat(file=stderr(), userValues$priorOwn, "TESTING I HATE R")
  
  # Initalize vector with zeros for each column
  weightVector <- rep(0, NUM_OF_FEATURES)
  
  # Add weights for age
  if (userValues$age <= 18) {
    weightVector[c(4,23:25)] <- weightVector[c(4,23:25)] + 1
  } else if (userValues$age <=64) {
    weightVector[4] <- weightVector[4] - .5
    weightVector[23:25] = weightVector[23:25] + 1
  } else if (userValues$age <=80) {
    weightVector[4] <- weightVector[4] + 1
    weightVector[23:25] <- weightVector[23:25] - .5
  } else {
    weightVector[4] <- weightVector[4] + 1
    weightVector[23:25] <- weightVector[23:25] - 1
  }
  
  # Add weights for pior dog ownership 
  weightVector[c(2,17)] <- weightVector[c(2,17)] + userValues$priorOwn
  weightVector[13:14] <- (if (userValues$priorOwn) weightVector[13:14] + 1 else weightVector[13:14] + .5)
  weightVector[19] <- (if (userValues$priorOwn) weightVector[19] - 1 else weightVector[19])
  
  # Add weights for activity level
  if (userValues$activeLvl == "Not Very Active") {
    weightVector[c(16:17,23,25:26)] <- weightVector[c(16:17,23,25:26)] + .33
  } else if (userValues$activeLvl == "Active") {
    weightVector[c(16:17,23,25:26)] <- weightVector[c(16:17,23,25:26)] + .66
  } else if (userValues$activeLvl == "Very Active") {
    weightVector[c(16:17,23,25:26)] <- weightVector[c(16:17,23,25:26)] + 1
  }
  
  # Add weights for home or apartment
  if (userValues$homeType == "apt") {
    weightVector[c(1,4,10)] <- weightVector[c(1,4,10)] + 1
    weightVector[c(16,22,25)] <- weightVector[c(16,22,25)] - 1
  } else {
    weightVector[c(4,10)] <- weightVector[c(4,10)] + .5
  }
  
  # Add weights for children
  weightVector[7:8] <- (if (userValues$children) weightVector[7:8] + 1 else weightVector[7:8])
  
  # Add weights for current dogs
  weightVector[9] <- (if (userValues$currDog) weightVector[9] + 1 else weightVector[9])
  
  # Add weights for allergy
  weightVector[c(11,13)] <- (if (userValues$allergy) weightVector[c(11,13)] + 1 else weightVector[c(11,13)])
  
  # Add weights for extreme heat
  if (userValues$hotScale == "Not Hot") {
    weightVector[6] <- weightVector[6] + .20
  } else if (userValues$hotScale == "Not Very Hot") {
    weightVector[6] <- weightVector[6] + .40
  } else if (userValues$hotScale == "Hot") {
    weightVector[6] <- weightVector[6] + .60
  } else if (userValues$hotScale == "Kinda Hot") {
    weightVector[6] <- weightVector[6] + .80
  } else if (userValues$hotScale == "Very Hot") {
    weightVector[6] <- weightVector[6] + 1
  }
  
  # Add weights for extreme cold
  if (userValues$coldScale == "Not Cold") {
    weightVector[5] <- weightVector[5] + .20
  } else if (userValues$coldScale == "Not Very Cold") {
    weightVector[5] <- weightVector[5] + .40
  } else if (userValues$coldScale == "Cold") {
    weightVector[5] <- weightVector[5] + .60
  } else if (userValues$coldScale == "Kinda Cold") {
    weightVector[5] <- weightVector[5] + .80
  } else if (userValues$coldScale == "Very Cold") {
    weightVector[5] <- weightVector[5] + 1
  }
  
  # Add weights for physical benifits
  weightVector[23:26] <- (if (userValues$physicalBen) weightVector[23:26] + 1 else weightVector[23:26] + .5)
  
  # Add weights for emotional benifits
  weightVector[c(10,18,23,25)] <- (if (userValues$emotionalBen) weightVector[c(10,18,23,25)] + 1 else weightVector[c(10,18,23,25)])
  
  # Add weights for noise level
  noiseWeight <- switch(userValues$noiseTol,
                        "Absolute Silence" = -1,
                        "A Little Noise" = -.8,
                        "Normal" = -.6,
                        "Loud" = -.4,
                        "Always Noisy" = -.2)
  
  weightVector[21] <- weightVector[21] + noiseWeight
  
  return(weightVector)
}

# Function: GetBreeds 
# ----------------------------
# Takes the weight vector and uses matrix multiplication to get a score 
# for each bread. It then ranks the top n and bottom n
# 
# userValues: a list of values from the form filled by user
#
# returns: a datafram with top n and bottom n breeds
GetBreeds <- function(userValues, n) {
  weightVector <- GenerateWeightVector(userValues)
  
  # Matrix multiplication (200x26 * 26x1 => 200x1)
  breedScores <- breedMatrix %*% weightVector
  
  # Add breed names to the scores
  breedScoresWithNames <- cbind(breedNames, breedScores)
  
  # Filter both top n and bottom n
  topBreeds <- breedScoresWithNames[apply(breedScores, 2, function(x) order(-x)[1:n])]
  lowerBreeds <- breedScoresWithNames[apply(breedScores, 2, function(x) order(x)[1:n])]
  
  # Package results in a dataframe
  returnDF <- cbind(topBreeds, lowerBreeds)
  colnames(returnDF) <- c("Top", "Bottom")
  
  return(returnDF)
}