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

  observeEvent(input$insertTab, {
    if(input$insertTab == "")
      return()

    insert_sidebar_item(
      input$insertTab,
      dashModuleUI(input$insertTab)
    )

    select_sidebar_item(input$insertTab)

    dash_module_server(input$insertTab)
    mason(sprintf("#%s-grid", gsub(" ", "", input$insertTab)))
  })

  observeEvent(input$addBlock, {
    offcanvas_show("blocks-offcanvas")
  })
}
