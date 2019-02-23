library(DMwR)
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

handler <- function(book1, book2, book3, book4, book5, book6, book7, book8, book9, book10, book11, book12, book13,
                    book14, book15, book16, book17, book18, book19, book20, ...) {
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
