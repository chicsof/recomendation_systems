setwd(dirname(sys.frame(1)$ofile))
books <- read.csv("../../data/books.csv")

handler <- function(...) {
	message(books)
	return(books)
}
