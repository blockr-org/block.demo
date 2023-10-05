# Launch the ShinyApp 
# do not remove to keep push deploy button
# from RStudio
pkgload::load_all(
	reset = TRUE,
	helpers = FALSE
)

library(blockr)

run(options = list(port = 3000L))
