handler <- function(pathParameters, ...){
  bookNumber <- pathParameters$bookNumber
  message("rules")
  sprintf("bookNumber: %s", bookNumber)

  result <- switch(
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
  sprintf("result: %s", result)
  return(result)
}
