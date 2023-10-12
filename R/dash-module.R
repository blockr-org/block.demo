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

      observeEvent(input$removeRow, {
        print(input$removeRow)
      })

      observeEvent(input$addStack, {
        stack_id <- make_id()

        stack <- new_stack(
          data_block
        )
        
        masonry_add_item(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          row_id = sprintf("#%s", input$addStack),
          item = generate_ui(stack, id = ns(stack_id))
        )

        add_block <- eventReactive(input$addBlock, {
          # it's for another stack
          if(input$addBlock$stackId != stack_id)
            return()

          block <- plot_block
          if(input$addBlock$type == "filter")
            block <- filter_block

          if(input$addBlock$type == "select")
            block <- select_block

          if(input$addBlock$type == "group_by")
            block <- group_by_block

          if(input$addBlock$type == "summarize")
            block <- summarize_block

          if(input$addBlock$type == "data")
            block <- data_block

          list(
            block = block,
            position = input$addBlock$blockIndex
          )
        })

        server <- generate_server(
          stack, 
          id = stack_id,
          new_blocks = add_block
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
    class = "btn bg-danger my-2 remove-row text-white",
    style = "margin-left:auto;"
  )
}
