setwd(dirname(sys.frame(1)$ofile))
books <- read.csv("../../data/books.csv")

handler <- function(pathParameters, ...){
	bookNumber <- pathParameters$bookNumber
	message("/closestThree")
	distDataSet <- get.distance(bookNumber)
	distDataSet <- distDataSet[! (distDataSet$CompBook==bookNumber),]
	orderedDistances <- distDataSet[order(distDataSet$totalDist, decreasing=FALSE), ]
	closest <- head(orderedDistances,3)
	return(closest$CompBook)
}

get.distance <- function(bookNumber){
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
