library(DMwR)
library(jsonlite)
setwd(dirname(sys.frame(1)$ofile))
readersFeedback <- read.csv("../../data/ratings.csv")

for (i in 1:20){
	assign(paste("book",i,sep=""), readersFeedback[readersFeedback$book==i,]$rate)
}

# Make a vector containing the readers in order
readers <- c(1:15)

# Now we make the new data set
readers.data <- data.frame(readers, book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11,
                           book12, book13, book14, book15, book17, book18, book19, book20)

completeMatrix <- knnImputation(readers.data, k = 3, scale = T, meth = "weighAvg", distData = NULL)

handler <- function(body, ...) {
	message("/rating")
	b <- fromJSON(body)

	null_to_na(b$book1)
	null_to_na(b$book2)
	null_to_na(b$book3)
	null_to_na(b$book4)
	null_to_na(b$book5)
	null_to_na(b$book6)
	null_to_na(b$book7)
	null_to_na(b$book8)
	null_to_na(b$book9)
	null_to_na(b$book10)
	null_to_na(b$book11)
	null_to_na(b$book12)
	null_to_na(b$book13)
	null_to_na(b$book14)
	null_to_na(b$book15)
	null_to_na(b$book16)
	null_to_na(b$book17)
	null_to_na(b$book18)
	null_to_na(b$book19)
	null_to_na(b$book20)


	getRecomendations(b$book1, b$book2, b$book3, b$book4, b$book5, b$book6, b$book7, b$book8, b$book9, b$book10,
	                  b$book11, b$book12, b$book13, b$book14, b$book15, b$book16, b$book17, b$book18, b$book19,
	                  b$book20)
}

null_to_na <- function(n) {
	if (is.null(n) ) {
		eval.parent(substitute(n <- NA ))
	}
}

getRecomendations <- function(book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12,
                              book13, book14, book15, book16, book17, book18, book19, book20) {

	# Since we dont have a log in page, we dont know who the user is. For now we can jsut assume this ratings are comming
	# from a new user so we need to add this new user number to our rating matrix
	newUserId <- nrow(readers.data) + 1

	# We capture his ratings in this vector
	newEntry <- c(newUserId, book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12,
	              book13, book14, book15, book16, book17, book18, book19, book20)

	# Then we add his ratings and umber to the existing matrix
	newMatrix <- rbind(readers.data,newEntry)

	# We fill in the gaps from missing ratings, as explained before using the function provided by the library
	completeMatrix <- knnImputation(newMatrix, k = 3, scale = T, meth = "weighAvg", distData = NULL)

	# Capture the users ratings after we filled in the gaps
	readersRatingComplete <- completeMatrix[completeMatrix$readers == newUserId,]
	# Capture the books that the user has not rated
	readersRatingsMissing <- which(is.na(newEntry))

	# Recomend books that the user has not rated and for which the predicted ratings are more than 3.4
	recommended <- integer()
	for (i in 2:20){
		if (i %in% readersRatingsMissing){
			if (readersRatingComplete[i] > 3.4) {
				recommended <- c(recommended, readersRatingComplete[i])
			}
		}
	}
	# Return the books that satisfy that :)
	return(recommended)
}
