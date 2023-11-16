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

  save <- reactiveVal(FALSE)
  saved <- reactiveVal(FALSE)
  observeEvent(input$save, {
    save(!save())
  })

  observeEvent(input$insertTab, {
    if(input$insertTab == "")
      return()

    # insert the tab into the custom dashboard
    insert_sidebar_item(
      input$insertTab,
      dashModuleUI(input$insertTab)
    )

    conf_tab_set(input$insertTab, input$insertTab)
    select_sidebar_item(input$insertTab)

    s <- dash_module_server(input$insertTab, save)

    # nested observeEvent is ugly: to change
    observeEvent(s(), {
      conf_layout_set(input$insertTab, s())
      saved(!saved())
    }, ignoreInit = TRUE)

    mason(sprintf("#%s-grid", gsub(" ", "", input$insertTab)))
  })

  observeEvent(saved(), {
    conf_serialise() |> print()
  })

  observeEvent(input$addBlock, {
    offcanvas_show("blocks-offcanvas")
  })

  home_server("home")
}
