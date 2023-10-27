#' home UI
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
homeUI <- function(id){
	ns <- NS(id)

  div(
    class = "p-4",
    div(
      class = "card bg-secondary",
      div( class = "card-body", h1("Block"),
        h2("Build, transform, visualise"),
        p(
          "Use the block system to transform your data",
          "and visualise it."
        )
      )
    ),
    div(
      class = "row mt-4",
      div(
        class = "col-md-4",
        div(
          class = "card",
          div(
            class = "card-body",
            h5(
              class = "card-title",
              "1. Import"
            ),
            p(
              class = "card-text",
              "Import data, and perform joins."
            )
          )
        )
      ),
      div(
        class = "col-md-4",
        div(
          class = "card",
          div(
            class = "card-body",
            h5(
              class = "card-title",
              "2. Transform"
            ),
            p(
              class = "card-text",
              "Transform your data, perform computations, and more."
            )
          )
        )
      ),
      div(
        class = "col-md-4",
        div(
          class = "card",
          div(
            class = "card-body",
            h5(
              class = "card-title",
              "3. Visualise"
            ),
            p(
              class = "card-text",
              "Create tables, and interactive graphs."
            )
          )
        )
      )
    ),
    div(
      class = "mt-4",
      h2("How it works"),
      tags$ul(
        class = "list-group",
        tags$li(
          class = "list-group-item",
          "1. Create a new tab on the left"
        ),
        tags$li(
          class = "list-group-item",
          "2. Create a new row"
        ),
        tags$li(
          class = "list-group-item",
          "3. Place your first stack in the row"
        ),
        tags$li(
          class = "list-group-item",
          "4. Add blocks to your stack"
        )
      )
    )
  )
}

#' home Server
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
home_server <- function(id){
	moduleServer(
		id,
		function(
			input, 
			output, 
			session
			){
				
				ns <- session$ns
				send_message <- make_send_message(session)

				# your code here
		}
	)
}

