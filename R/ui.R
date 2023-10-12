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
#' @import bsutils
#' @importFrom bslib bs_theme
#' 
#' @keywords internal
ui <- function(req){
  assets()

	bmsPage(
    masonryDependencies(),
    tags$head(
      tags$script(src = "static/add-stack.js"),
      tags$link(rel = "stylesheet", href = "static/styles.css")
    ),
    navbar = navbar(
      title = "Block R",
      alignment = "right",
      fixed = TRUE,
      navbarItem(
        tags$button(
          class = "btn btn-secondary add-stack",
          "Stack",
          icon("plus")
        )
      ),
      navbarItem(
        actionButton(
          "addBlock",
          class = "button-secondary",
          "Blocks"
        )
      )
    ),
    sidebar = sidebar(
      title = h3("Menu", class = "mt-0 pt-0"),
      sidebarItem(
        "Home",
        div(
          class = "p-4",
          div(
            class = "card bg-secondary",
            div(
              class = "card-body",
              h1("Block R"),
              h2("Build, transform, visualise"),
              p(
                "Use the block system to transform your data",
                "and visualise it."
              )
            )
          )
        )
      ),
      sidebarItemAny(
        togglerTextInput(
          "insertTab",
          "Add tab"
        )
      )
    ),
    offcanvasContent(
      id = "blocks-offcanvas",
      .position = "bottom",
      scroll = TRUE,
      offcanvasHeader(h4("Blocks")),
      div(
        class = "row",
        div(
          class = "col-md-3",
          h5("Data"),
          div(
            class = "block-wrapper",
            blockPill(
              "Data",
              color = "secondary"
            )
          )
        ),
        div(
          class = "col-md-3",
          h5("Transform"),
          div(
            class = "block-wrapper",
            blockPill(
              "Select"
            ),
            blockPill(
              "Filter",
              color = "info"
            ),
            blockPill(
              "Group by",
              type = "group_by",
              color = "success"
            ),
            blockPill(
              "Summarize",
              color = "danger"
            )
          )
        ),
        div(
          class = "col-md-3",
          h5("Visualise"),
          div(
            class = "block-wrapper",
            blockPill(
              "Plot",
              color = "warning"
            )
          )
        )
      )
    ),
    div(
      class = "toast-container position-fixed bottom-0 end-0 p-3",
      div(
        id = "toast",
        class = "toast text-bg-secondary",
        div(
          class = "toast-body",
          id = "toast-body",
        )
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
#' @importFrom shiny tags
#' 
#' @keywords internal
assets <- function(){
  addResourcePath("static", system.file("assets", package = "block.demo"))
}

make_id <- function(){
  c(letters, 1:9) |>
    sample() |>
    (\(.) paste0(., collapse = ""))() |>
    (\(.) sprintf("_%s", .))()
}

blockPill <- function(title, type = tolower(title), color = "primary"){
  p(title, `data-type` = type, class = sprintf("badge w-100 add-block bg-%s", color))
}
