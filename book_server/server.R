setwd("/app")

#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* @get /mean
normalMean <- function(samples=10){
  message("/mean")
  data <- rnorm(samples)
  mean(data)
}

# @post /sum
# addTwo <- function(a, b){
#   message("hello")
#   as.numeric(a) + as.numeric(b)
# }

trim_array_string <- function (x) gsub("^\\[|\\]", "", x)
split_array_string <- function (x) strsplit(x, ",+")

#* @post /test
testing <- function(list){
  message("/test")
  message(list)
  trimmed_array_string <- trim_array_string(list)
  message(trimmed_array_string)
  message(typeof(trimmed_array_string))
  jim <- unlist(strsplit(trimmed_array_string, split="\\s*,\\s*"))
  message(jim)
  message(typeof(jim))
  bob <- as.numeric(jim)
  message(bob)
  message(typeof(bob))
  sum(bob)
}







books <- read.csv("books.txt")

#* @get /books
get_books <- function(){
  books
}

#* @post /closestThree
getClosest3 <- function(bookNumber){
  message("/closestThree")
  distDataSet <- get.distance(bookNumber)
  distDataSet <- distDataSet[! (distDataSet$CompBook==bookNumber),]
  orderedDistances <- distDataSet[order(distDataSet$totalDist, decreasing=FALSE), ]
  closest <- head(orderedDistances,3)
  return(closest$CompBook)
}

get.distance <- function(bookNumber){
  # message(bookNumber)
  # 2
  df <- data.frame(CompBook=integer(),
                   hammingDist=integer(),
                   ageDist = integer(),
                   totalDist = integer())

  author <- books[books$book==bookNumber,]$author
  genre <- books[books$book==bookNumber,]$genre
  age <- books[books$book==bookNumber,]$age


  for (i in 1:20){
    authorComp <- books[books$book==i,]$author
    genreComp <- books[books$book==i,]$genre
    ageComp <- books[books$book==i,]$age

    hammingDistance <- 0
    ageDist <- 0
    totalDist <- 0
    if (author != authorComp) {
      hammingDistance = hammingDistance + 1
    }

    if (genre != genreComp) {
      hammingDistance = hammingDistance + 1
    }

    ageDist <- abs(age - ageComp)

    if (ageDist > 10) {
      totalDist <- hammingDistance + 0.5
    } else if (ageDist > 5) {
      totalDist <- hammingDistance + 0.25
    } else {
      totalDist <- hammingDistance
    }

    newdata <- c(i, hammingDistance,ageDist, totalDist)
    df<- rbind(df, newdata)
    names(df) <- c("CompBook", "hammingDist", "ageDist", "totalDist")

  }

  return(df)

}





# Feedback

readersFeedback <- read.csv("readersFeedback.txt")
for (i in 1:20){
  #message("Hey")
  assign(paste("book",i,sep=""), readersFeedback[readersFeedback$book==i,]$rate)
}
#make a vector containing the readers in order
readers <- c(1:15)

#now we make the new data set
readers.data <- data.frame(readers, book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11,
                           book12, book13, book14, book15, book17, book18, book19, book20)

library(DMwR)
completeMatrix <- knnImputation(readers.data, k = 3, scale = T, meth = "weighAvg",
                                distData = NULL)

#message("yo")
#message(completeMatrix)

null_to_na <- function(n) {
  if (is.null(n) ) {
    eval.parent(substitute(n <- NA ))
  }
}

#* @post /rating
ratingWrapper <- function(book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12, book13,
                          book14, book15, book16, book17, book18, book19, book20) {
  message("/rating")
  null_to_na(book1)
  null_to_na(book2)
  null_to_na(book3)
  null_to_na(book4)
  null_to_na(book5)
  null_to_na(book6)
  null_to_na(book7)
  null_to_na(book8)
  null_to_na(book9)
  null_to_na(book10)
  null_to_na(book11)
  null_to_na(book12)
  null_to_na(book13)
  null_to_na(book14)
  null_to_na(book15)
  null_to_na(book16)
  null_to_na(book17)
  null_to_na(book18)
  null_to_na(book19)
  null_to_na(book20)

  getRecomendations(book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12, book13,
                    book14, book15, book16, book17, book18, book19, book20)
}

getRecomendations <- function(book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12,
                              book13, book14, book15, book16, book17, book18, book19, book20){

  #since we dont have a log in page, we dont know who the user is. For now we can jsut assume this ratings are comming from a new user
  #so we need to add this new user number to our rating matrix
  newUserId <- nrow(readers.data) + 1

  #we capture his ratings in this vector
  newEntry <- c(newUserId, book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12,
                book13, book14, book15, book16, book17, book18, book19, book20)

  #then we add his ratings and umber to the existing matrix
  newMatrix <- rbind(readers.data,newEntry)

  #we fill in the gaps from missing ratings, as explained before using the function provided by the library
  completeMatrix <- knnImputation(newMatrix,
                                  k = 3,
                                  scale = T,
                                  meth = "weighAvg",
                                  distData = NULL)

  #capture the users ratings after we filled in the gaps
  readersRatingComplete <- completeMatrix[completeMatrix$readers == newUserId,]
  #capture the books that the user has not rated
  readersRatingsMissing <- which(is.na(newEntry))

  #recomend books that the user has not rated and for which the predicted ratings are more than 3.4
  recommended <- integer()
  for (i in 2:20){
  if (i %in% readersRatingsMissing){
    if(readersRatingComplete[i] > 3.4){
      recommended <- c(recommended, readersRatingComplete[i])
    }
   }
  }

  #return the books that sutisfy that :)
  return( recommended)

}




# Rules
#* @post /rules
useRules <- function(bookNumber){
  message("/rules")
  switch(
    toString(bookNumber),
    "1"=2,
    "3"=1,
    "4"=2,
    "12"=11,
    "16"=c(17,18),
    "17"=2,
    "18"=17,
    "19"=18,
    {0}
  )
}
