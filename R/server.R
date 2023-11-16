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

    insert_tab(input$insertTab, save, saved, select = TRUE)
  })

  observeEvent(saved(), {
    print(conf_serialise())
    conf_serialise() |>
      writeLines("conf.json")
  }, ignoreInit = TRUE)

  observe({
    conf_restore(conf, save)
  })

  observeEvent(input$addBlock, {
    offcanvas_show("blocks-offcanvas")
  })

  # read conf
  conf <- list()
  if(file.exists("conf.json"))
    conf <- jsonlite::read_json("conf.json")

  home_server("home")
}
