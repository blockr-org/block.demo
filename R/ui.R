#' Shiny UI
#' 
#' Core UI of package.
#' 
#' @param req The request object.
#' 
#' @import shiny
#' @import bmsui
#' @import masonry
#' @import blockr
#' @importFrom bslib bs_theme
#' 
#' @keywords internal
ui <- function(req){
	bmsPage(
    navbar = navbar(
      title = "Example application",
      navbarItem("Profile")
    ),
    sidebar = sidebar(
      title = h3("Menu", class = "mt-0 pt-0"),
      sidebarItem(
        "Home",
        tagList(
          h1("Masonry"),
          masonryGrid(
            id = "firstGrid",
            masonryRow(
              class = "bg-dark text-dark",
              masonryItem(uiOutput("stack1"))
            ),
            masonryRow(
              class = "bg-dark text-dark",
              masonryItem(uiOutput("stack2")),
              masonryItem(uiOutput("stack3"))
            ),
            options = list(margin = ".5rem")
          )
        )
      ),
      sidebarItem(
        "Masrony",
        masonryUI("masonry")
      ),
      sidebarItem(
        "Basic",
        basicUI("basic")
      )
    )
	)
}

#' Assets
#' 
#' Includes all assets.
#' This is a convenience function that wraps
#' [serveAssets] and allows easily adding additional
#' remote dependencies (e.g.: CDN) should there be any.
#' 
#' @param ignore A vector of files to ignore.
#' This can be useful for scripts that should not be 
#' placed in the `<head>` of the HTML.
#' 
#' @importFrom shiny tags
#' 
#' @keywords internal
assets <- function(ignore = NULL){
	list(
		serveAssets(ignore = ignore), # base assets (assets.R)
		tags$head(
			# Place any additional depdendencies here
			# e.g.: CDN
		)	
	)
}
