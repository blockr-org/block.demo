#' home UI
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
masonryUI <- function(id){
	ns <- NS(id)

	tagList(
    h1("Masonry"),
    masonryGrid(
      id = "firstGrid",
      masonryRow(
        class = "bg-dark text-dark",
        masonryItem(uiOutput(ns("stack1")))
      ),
      masonryRow(
        class = "bg-dark text-dark",
        masonryItem(uiOutput(ns("stack2"))),
        masonryItem(uiOutput(ns("stack3")))
      ),
      options = list(margin = ".5rem")
    )
	)
}

#' home Server
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
masonry_server <- function(id){
	moduleServer(
		id,
		function(
			input, 
			output, 
			session
    ){
      ns <- session$ns
      send_message <- make_send_message(session)

      stack1 <- new_stack(
        new_data_block,
        new_filter_block
      )

      output$stack1 <- renderUI({
        block.shiny::generate_ui(stack1)
      })

      generate_server(stack1)

      stack2 <- new_stack(
        new_data_block,
        new_filter_block
      )

      output$stack2 <- renderUI({
        block.shiny::generate_ui(stack2)
      })

      generate_server(stack2)

      stack3 <- new_stack(
        new_data_block,
        new_filter_block
      )

      output$stack3 <- renderUI({
        block.shiny::generate_ui(stack3)
      })

      generate_server(stack3)
  })
}

# UI
# homeUI('id')

# server
# home_server('id')
