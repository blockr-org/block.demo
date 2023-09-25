#' Server
#' 
#' Core server function.
#' 
#' @param input,output Input and output list objects
#' containing said registered inputs and outputs.
#' @param session Shiny session.
#' 
#' @noRd 
#' @keywords internal
server <- function(input, output, session){
	send_message <- make_send_message(session)	
  masonry_server("masonry")
  basic_server("basic")

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
}
