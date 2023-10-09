dashModuleUI <- function(id){
  ns <- NS(id)

  div(
    class = "p-4 dash-page",
    `data-ns` = ns(NULL),
    div(
      class = "d-flex",
      div(
        class = "flex-grow-1",
        togglerTextInput(
          make_id(),
          h1(id),
          value = id,
          restore = TRUE
        )
      ),
      div(
        class = "flex-shrink-1",
        actionButton(ns("addRow"), "Row", icon = icon("plus"), class = "bg-secondary")
      )
    ),
    togglerTextInput(
      make_id(),
      p("Description"),
      value = "Page description",
      restore = TRUE
    ),
    masonryGrid(
      id = sprintf("%s-grid", gsub(" ", "", id)),
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
      ns <- session$ns

      observeEvent(input$addRow, {
        masonry_add_row(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          newRowRemoveUI()
        )
      })

      stacks <- list()

      observeEvent(input$addStack, {
        ...stack <- new_stack(
          data_block,
          filter_block,
          plot_block
        )
        
        masonry_add_item(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          row_id = sprintf("#%s", input$addStack),
          item = generate_ui(...stack, id = gsub(" ", "", ns(id)))
        )

        ...server <- generate_server(...stack, id = gsub(" ", "", id))
        stacks <<- append(stacks, list(list(id = gsub(" ", "", id), stack = ...stack, server = ...server)))
      })

      observeEvent(input$addBlock, {
        print(input$addBlock)

        stack <- stacks |> purrr::keep(\(block){
          block$id == input$addBlock$id
        })

        block <- plot_block
        if(input$addBlock$type == "filter")
          block <- filter_block

        if(input$addBlock$type == "select")
          block <- select_block
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
    class = "btn bg-danger my-2 remove-row text-white",
    style = "margin-left:auto;"
  )
}
