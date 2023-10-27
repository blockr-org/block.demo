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
          "Blocks",
          icon("cube")
        )
      )
    ),
    sidebar = sidebar(
      title = h3("Menu", class = "mt-0 pt-0"),
      sidebarItem(
        "Home",
        homeUI("home")
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
      .position = "end",
      scroll = TRUE,
      offcanvasHeader(h4("Blocks")),
      p("Drag the block in the stack where you want to insert it."),
      h5("Data"),
      div(
        class = "block-wrapper",
        blockPill(
          "Data",
          icon("table"),
          class = "data_block",
          type = "dataset_block",
          color = "secondary"
        ),
        blockPill(
          "CDISC",
          icon("table"),
          class = "cdisc_block",
          type = "dataset_block",
          color = "secondary"
        ),
        blockPill(
          "Join",
          icon("object-ungroup"),
          class = "data_block",
          type = "join_block",
          color = "secondary"
        )
      ),
      h5("Transform"),
      div(
        class = "block-wrapper",
        blockPill(
          "Select",
          icon("hand-pointer"),
          class = "transform_block",
          color = "info"
        ),
        blockPill(
          "Filter",
          icon("filter"),
          class = "transform_block",
          color = "info"
        ),
        blockPill(
          "Arrange",
          icon("sort"),
          class = "transform_block",
          color = "info"
        ),
        blockPill(
          "Group by",
          icon("object-group"),
          class = "transform_block",
          type = "group_by_block",
          color = "info"
        ),
        blockPill(
          "Summarize",
          icon("layer-group"),
          class = "transform_block",
          color = "info"
        ),
        blockPill(
          "Factor",
          icon("chart-bar"),
          class = "transform_block",
          type = "as_factor_block",
          color = "info"
        )
      ),
      h5("Visualise"),
      div(
        class = "block-wrapper",
        blockPill(
          "Plot",
          icon("chart-bar"),
          class = "output",
          color = "success",
          type = "plot_block"
        ),
        blockPill(
          "Interactive Plot",
          icon("chart-bar"),
          class = "output",
          color = "success",
          type = "ggiraph_block"
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

blockPill <- function(title, ..., class, type = paste0(tolower(title), "_block"), color = "primary"){
  p(title, ..., `data-class` = class, `data-type` = type, class = sprintf("mb-1 w-100 badge add-block bg-%s", color))
}
