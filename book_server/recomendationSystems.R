# Change this to your target directory
setwd("~/Projects/statistical_analysis/recomendation_systems")

#import our data ( i made those files with some random data that i though looked reasonable)

#books contain the book number (from 1 to 20), the author (a,b,c,d), the genre (piret,alien,love,drama)
#and how many years ago the book was written
books <- read.csv("books.txt")

#this is a list of 8 usures that have rated our books from 1 to 5 (where 5 is perfect)
# not every users has rated every book
readersFeedback <- read.csv("readersFeedback.txt")

# this is a list of transactions where the users bought books, users can buy books one at a time, in pairs, three at a time and so on
# transaction number is used to distinjuise what books each users bought each time. We can see what books users tend to buy together
transactions <- read.csv("transactions.txt")

########################################### recomend 'similar books'#################################################################
# fist we will create the algorithm that is used to recomend 'similar books' to the one the user just bought.
# That algorithm will simply look at how similar the book we just bought is, to ather books avalable, acorsing to the given attributes
# (author, genre, age). This aproach is called Content based filtering.

###### What is similarity ?
# To understand how we find similarity, we can imagine ploting all of our points, using their attributes as coordinates. The closer
# each point is to another the more 'similar' they whould be. For example if we only used the x axis (a straigh line), whose values
# represent the age of each book. We chould then mark where on that line each book is according to its age. Marks that are close to
# each other whould show us books that have similar age. To define 'similarity' in a more realistic manner we need to use the rest of
# our attributes. So instead of just a line we plot our points in a graph where each axis (known as dimention) represent an attribute.
# For those interested, there are 3 main ways of computing distances between 2 points in an n-dimentional space
#> Euclidian distance. Similar to computing distances in 2 dimentional distances, we use the co-rdinates of the points to draw a
#right triangle with two known sides and compute the unknown, wich represents the distance, using the pythagorium theorum
#> Correlation distance. Basicly measures how 'in-synch' (do they both go up or down) the diviations from the mean of each point are
# for each user. Users that have rated the same product higher than their avagare and the same products lower than their avarage
#are considered close to each other.
#>Hammer distance. Simply measures the persentage of agreement. How many times two users gave the exact same rating.

###### How can we find the most similar books?
# We can use K-Nearest-Neibours (KNN) to get a defined number of books that are closer to the book we just bough. The algorithm will
# identify the K closest points on the imaginery grath where each attribute is a dimention. (for now this is all you need to know for
# KNN, I discuss further the algorithm at https://chicsof.tech)


# to measure distances in a way that makes sence, we dont want the book number to be part of the attributes used to describe
# similarity so we will remove it (we still keep the order however, as later on we need to identify the book number)
booksNoNumber <- books
booksNoNumber$book <- NULL
booksNoNumber

bookInfo <- function(bookNumber){
bookInfo <- books[books$book == bookNumber,]
bookInfo$book <- NULL
return(bookInfo) }

getClosest3 <- function(bookNumber){
  distDataSet <- get.distance(bookNumber)
  distDataSet <- distDataSet[! (distDataSet$CompBook==bookNumber),]
  orderedDistances <- distDataSet[order(distDataSet$totalDist, decreasing=FALSE), ]
  closest <- head(orderedDistances,3)
  return(closest$CompBook)
}

getClosest3(12)


get.distance(12)
get.distance <- function(bookNumber){

  df <- data.frame(CompBook=integer(),
                   hammingDist=integer(),
                   ageDist = integer(),
                   totalDist = integer())

  author <-books[books$book==bookNumber,]$author
  genre <- books[books$book==bookNumber,]$genre
  age <- books[books$book==bookNumber,]$age


  for (i in 1:20){
  authorComp  <-books[books$book==i,]$author
  genreComp  <- books[books$book==i,]$genre
  ageComp  <- books[books$book==i,]$age

  hammingDistance <- 0
  ageDist <- 0
  totalDist <-0
  if (author != authorComp){
    hammingDistance = hammingDistance+1
  }

  if (genre != genreComp){
    hammingDistance = hammingDistance+1
  }

  ageDist <- abs(age - ageComp)

  if (ageDist > 10) {
    totalDist <- hammingDistance + 0.5
  }else if (ageDist > 5){
    totalDist <- hammingDistance + 0.25
  }else{
      totalDist <-hammingDistance
    }

  newdata <- c(i, hammingDistance,ageDist, totalDist)
  df<- rbind(df, newdata)
  names(df) <- c("CompBook", "hammingDist", "ageDist", "totalDist"  )

  }

  return(df)

}


########################################### recomend books liked by 'similar' users ################################################

#####Similar users?
#the idea here is that we use the rating matrix (see image 2) and try to fill in the gaps, from missing ratings. Once this is done
#we recomend books to users that had missing ratings and after filling them, they where found to very possitive (like a 4 or a 5).
#This aproach means that we do not require any information on each book. We can simply find groups of users with similar ratings,
#and suggest books that have been rated high within that group. Again similarity can be identified by how close those points are
# from each other.
# whould be able to do this. Once we have found a couple of readers similar to reader A, we can take a weighted
# (by how close each reader is to A, the closer the more significant) avarage rating for a specific film and use that as the
# predicted rating for A, who has not rated that film. If that is found to be possitive we will recomend the book to A.

#so first we need to create the rating matrix as shown in the image. At the moment we have normalized data (user, book, rating)
# so we have 20 entries for each user. This is not usufull if we want to find the distance of each user using his ratings. The
# ratings are the attributes that need to used as coordinates to plot each point.So we need to transform that data to a data that
# has one entry for each user, and 20 columns one for each book.

#first we make the 20 vectors containing the ratings for each user, those will be pour coloumns
for (i in 1:20){
  assign(paste("book",i,sep=""), readersFeedback[readersFeedback$book==i,]$rate)
}
#make a vector containing the readers in order
readers <- c(1:15)

#now we make the new data set
readers.data <- data.frame(readers, book1, book2,book3,book4,book5,book6,book7,book8,book9,book10,book11,book12,book13,book14,book15
                                    ,book17,book18,book19,book20)

install.packages("DMwR")
library(DMwR)
completeMatrix <- knnImputation(readers.data, k = 3, scale = T, meth = "weighAvg",
              distData = NULL)

completeMatrix

getRecomendations <- function(book1, book2,book3,book4,book5,book6,book7,book8,book9,book10,book11,book12,book13,book14,book15
                              ,book16,book17,book18,book19,book20){


  newUserId <- nrow(readers.data) + 1
  newEntry <- c(newUserId, book1, book2,book3,book4,book5,book6,book7,book8,book9,book10,book11,book12,book13,book14,book15
                ,book16,book17,book18,book19,book20)

  newMatrix <- rbind(readers.data,newEntry)
  completeMatrix <- knnImputation(newMatrix, k = 3, scale = T, meth = "weighAvg",
                                  distData = NULL)

  readersRating <- completeMatrix[completeMatrix$readers == newUserId,]
  recommended <- integer()
  for (i in 2:20){
    if(readersRating[i]>4){
      recommended <- c(recommended, readersRating[i])
    }

  }

  return(recommended)

}


getRecomendations(5,NA,5,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,2,1,1,NA,NA)




######Laten Factor Analysis
#KNN is fine but you can try something different.This time we chould try to identify the underlaying
#factors that caused each user to rate each film the way the did, we then use those factors to extrapolate (predict) what their
#rating whould be for the rest of the films. This is called Laten Factor Analysis.

#We will assume that there is a factor/combination of factors for each reader that makes them rate books a specific way.
# (e.g. a reader is into drama books). We will aslo assume that there is a factor/combination of factors relevant to each
# book that result in bad/good rating (e.g. the author is very popular).

# Those underling factors are can be identified using PCA. I discuss more about PCA at https://chicsof.tech, but for now all you need
# to know is that we can sohow tell which are the main factors are motivating reader to give sertain ratings and books to receive sertain
#ratings.

#We do not, however, have the values associated with each book and each reader. We only have the outcomes that were produced by
#combining the factors of each user with each product (those are the ratings!). So for every rating we have rating = F_reader * F_book

# Each user has its own set of equations, and all we need to do is solve for F_reader and F_book. The issue is that not all the
# ratings are avalable for each user, meaning that we will not be able to find the exact numbers. There will always be an error,
#In other words rating - (F_reader * F_book) will not be zero.

# To estimates the factors in the best way we can, we will attempt to find some F_reader F_book, that minimizes the error. (There
# are various techniques for that such us the stocastic gradient disent that attempts to find a local minimum by trial... )

#Once we have those values we can simply use them to fill in any gap in the matrix. For example, lets say we didn't know the rating
# reader 1 gave for book 12. We had however anought data to calculate a factor 2 for that user and a factor 2 for that book.
# The rating whould be 4, and so we should recomend book 12 to reader 1. (of cource this is a very simplified example to discribe the
# underlying mechanics. In reality a lot more factors whould be involved and we whould also need to account for other issues such
# us overfitting in our equestions)


# Find more here https://blogs.rstudio.com/tensorflow/posts/2018-09-26-embeddings-recommender/

# There are other well-known methods for identifying 'similar' users, such us the Pearson method. Here the rating of each user is
# treated as a vector

###################### Recomendings items that are often bought together (mining data rules)
# We want to look at the transaction history and recomend items that users tend to buy together or over a short period of time.
# This approach to recomandation systems is called assosiation rules learning. Given that a user just bough an item we want to find
#out how likely he is to buy other 'assosiated' items and recomend the ones we are most confident that the user will be interested
#in.

##to understand how this works, lets use the example where we want to find out if we should recomend book 2 to a user that just
#bought book 1 (only by looking at the transcation history of our shop). In other words, we want to find out if the assosiation
# rule of bying 2 given that we bough 1 is strong enough.

#To measure the strenght of 'assisiation' between some items, we se use the following metrics:

#> First we identify what proportion of all the transactions include both book 1 and book 2, this is called the Support of this rule.
# A high support means that there are a lot of transations were both items have been bought together.

#> This is some evidence that there is a strong relationship. However there is a chance that book 2 just happens to be very
#popular and is just bought a lot in various transactions. We want to be able to deal with such cases, this is what Confidence
#measures. We want to measure how often book 1 and 2 are sold together as opposed to book 2. This is given by the ratio
# of the proportion of all transactions that included both 1,2 (support) over the proportion of just 2.
#It is nothing more than the conditional propability of 2 given 1.


#> Last we want to find out how much the propability of a user buying book 2 has increased once he bought book 1. This is called
# Lift. So the original propability of bying book 2, is just the proportion of all transactions that include book 2. The
# propability of bying 2 given that we have just bought 1 is what we just measured above, the confidence. If we divide the original
# propability of buying 2 to the coditional propability of 2 given 1, we can measure what is called Lift. A hight lift measurment
# means that the liklyhood of the reader byuing 2 once he bought 1 has increaed.

# FOr an assisiation rule to be considered we want to have a hight Support Confidence and Lift

#We now have an understanding of how we measure 'assosiation' between products. But how do we go about selecting which products to measure
#that assosiation for in the first place. Well one approach is to brute force it. Measure all the assosiations for every 2 possible pairs between
#our products, then the 3 pairs, the 4 pairs untill we reach n pairs of products that are possible. From all those measurments we then pick
#the assosications with the hiest strenghts. This is clearly computationally expensive.

#There are various aproaches to this problem, a popular one, which we will use is the Apriori algorithm.
#This algorithm investigates assosiations incrementally, it starts from single variables, pairs of 1, 2, 3 and so on. Every time
#it checks if the pairs sutisfy a minimum support value, the pairs that do are used to generate rules. It then moves to the next
#pairs, using only the items that were left out priviously. It repeats until no items are left, that can sutisfy that minimun support
#threshold.


install.packages("arules")

library(arules)
#for R to use the ransaction hostory it mast be of type transaction,
#either in a basket format or in a normilized single format
trans = read.transactions("transactionsNoUserName.txt", format = "single", sep = ",", cols = c(1,2))
inspect(trans)
#use the algorithm
assoc_rules <- apriori(trans, parameter = list(sup = 0.03, conf = 0.6,target="rules"));
#inspect rules that were found
inspect(assoc_rules)
?apriori

useRules(4)

useRules <- function(bookNumber){
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
