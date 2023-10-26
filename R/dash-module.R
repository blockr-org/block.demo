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
          demo_data_block,
          name = "New Stack"
        )
        
        masonry_add_item(
          sprintf("#%s-grid", gsub(" ", "", id)), 
          row_id = sprintf("#%s", input$addStack),
          item = generate_ui(stack, id = ns(stack_id))
        )

        new_block <- eventReactive(input$addBlock, {
          # it's for another stack
          if(input$addBlock$stackId != stack_id)
            return()

          print(input$addBlock)

          block <- plot_block
          if(input$addBlock$type == "filter_block")
            block <- filter_block

          if(input$addBlock$type == "cdisc_block")
            block <- demo_data_block 

          if(input$addBlock$type == "select_block")
            block <- select_block

          if(input$addBlock$type == "group_by_block")
            block <- demo_group_by_block

          if(input$addBlock$type == "summarize_block")
            block <- demo_summarize_block

          if(input$addBlock$type == "dataset_block")
            block <- data_block

          if(input$addBlock$type == "arrange_block")
            block <- demo_arrange_block

          if(input$addBlock$type == "cheat_block")
            block <- cheat_block

          if(input$addBlock$type == "ggiraph_block")
            block <- ggiraph_block

          if(input$addBlock$type == "join_block")
            block <- demo_join_block

          if(input$addBlock$type == "as_factor_block")
            block <- as_factor_block

          list(
            block = block,
            position = input$addBlock$blockIndex
          )
        })

        server <- generate_server(
          stack, 
          id = stack_id,
          new_blocks = new_block
        )

        observeEvent(server$remove, {
          if(!server$remove)
            return()

          # TODO remove stack server-side
        })
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
    class = "btn btn-sm bg-danger my-2 remove-row text-white position-absolute top-0 start-0",
    style = "margin-left:auto;"
  )
}
