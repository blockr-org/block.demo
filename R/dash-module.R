dashModuleUI <- function( # nolint
  id, 
  title = tools::toTitleCase(id), 
  description = "description"
){
  ns <- NS(id)

  div(
    class = "p-4 dash-page",
    `data-ns` = ns(NULL),
    div(
      class = "d-flex",
      div(
        class = "flex-grow-1",
        togglerTextInput(
          ns("title"),
          h1(title),
          value = id,
          restore = TRUE
        )
      ),
      div(
        class = "flex-shrink-1",
        actionButton(
          ns("addRow"), 
          "Row", 
          icon = icon("plus"), 
          class = "bg-secondary add-row"
        )
      )
    ),
    togglerTextInput(
      ns("description"),
      p(description),
      value = "Page description",
      restore = TRUE
    ),
    masonryGrid(
      id = sprintf("%s-grid", gsub(" ", "", id)) |> ns(),
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

dash_module_server <- function(id, save){ # nolint
  moduleServer(
    id, 
    function(input, output, session){
      ns <- session$ns

      observeEvent(input$title, {
        conf_tab_set(id, input$title, input$description)
      })

      observeEvent(input$description, {
        conf_tab_set(id, input$title, input$description)
      })

      observeEvent(save(), {
        masonry_get_config(sprintf("%s-grid", gsub(" ", "", id)) |> ns())
      }, ignoreInit = TRUE)

      state <- reactiveValues(layout = list(), stacks = list())
      observeEvent(input[[sprintf("%s-grid_config", gsub(" ", "", id))]], {
        state$layout <- input[[sprintf("%s-grid_config", gsub(" ", "", id))]]
      })

      observeEvent(input$addRow, {
        masonry_add_row(
          sprintf("#%s-grid", gsub(" ", "", ns(id))), 
          newRowRemoveUI()
        )
      })

      observeEvent(input$removeRow, {
        print(input$removeRow)
      })

      stacks <- list()
      observeEvent(input$addStack, {
        stack_id <- make_id()

        stack <- new_stack(
          demo_data_block,
          name = "New Stack"
        )
        
        masonry_add_item(
          sprintf("#%s-grid", gsub(" ", "", ns(id))), 
          row_id = sprintf("#%s", input$addStack),
          item = generate_ui(stack, id = ns(stack_id))
        )

        new_block <- eventReactive(input$addBlock, {
          # it's for another stack
          if(input$addBlock$stackId != stack_id)
            return()

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
          
          if(input$addBlock$type == "head_block")
            block <- head_block

          if(input$addBlock$type == "as_factor_block")
            block <- asfactor_block

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

        observeEvent(server$stack, {
          state$stacks[[stack_id]] <<- lapply(server$stack, as_list)
        })

        observeEvent(server$remove, {
          if(!server$remove)
            return()

          # TODO remove stack server-side
        })
      })

      return(state)
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

newRow <- function(...){ # nolint
  masonryRow(
    classes = "position-relative",
    newRowRemoveUI(),
    ...
  )
}

newRowRemoveUI <- function(){ # nolint
  tags$button(
    icon("times"),
    class = "btn btn-sm bg-danger my-2 remove-row text-white position-absolute start-0",
    style = "margin-left:auto;"
  )
}
