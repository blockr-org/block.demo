# Launch the ShinyApp 
# do not remove to keep push deploy button
# from RStudio
pkgload::load_all(
  reset = TRUE,
  helpers = FALSE
)

library(blockr.data)
library(ggiraph)

options(shiny.fullstracktrace = TRUE)

run(options = list(port = 3000L))
