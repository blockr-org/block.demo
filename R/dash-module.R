dashModuleUI <- function(id){
  ns <- NS(id)

  div(
    class = "p-4 dash-page",
    `data-ns` = ns(NULL),
    div(
      class = "row",
      div(
        class = "col-md-8",
        togglerTextInput(
          make_id(),
          h1(id),
          value = id,
          restore = TRUE
        )
      ),
      div(
        class = "col-md-4",
        actionButton(ns("addRow"), "Row", icon = icon("plus"), class = "bg-secondary"),
        tags$button(
          class = "btn btn-secondary add-stack",
          "Stack",
          icon("plus")
        )
      )
    ),
    masonryGrid(
      id = sprintf("%s-grid", gsub(" ", "", id)),
      newRow(),
      styles = list(
        rows = list(
          margin = "1rem",
          `min-height` = "5rem"
        ),
        items = list(
          margin = ".5rem"
        )
      )
    )
  )
}

dash_module_server <- function(id){
  moduleServer(
    id, 
    function(input, output, session){
      observeEvent(input$addRow, {
        masonry_add_row(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          newRowRemoveUI()
        )
      })

      observeEvent(input$addStack, {
        masonry_add_item(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          row_id = sprintf("#%s", input$addStack),
          item = card(h1("Stack"))
        )
      })
    }
  )
}

card <- \(...){
  div(
    class = "card border",
    div(
      class = "card-body bg-white text-dark",
      ...
    )
  )
}

newRow <- function(...){
  masonryRow(
    classes = "position-relative",
    newRowRemoveUI(),
    ...
  )
}

newRowRemoveUI <- function(){
  tags$button(
    icon("times"),
    class = "btn bg-danger remove-row",
    style = "margin-left:auto;"
  )
}
