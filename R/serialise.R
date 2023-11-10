env <- new.env()
env$config <- list(
  tabs = list()
)

conf_tab_add <- \(id, title = "Title", description = "Description"){
  env$config$tabs <- append(
    env$config$tabs,
    list(
      id = list(
        id = id,
        title = title,
        description = description,
        stacks = list()
      )
    )
  )
}

conf_tab_set_stacks <- \(id, stacks) {
  env$config[[id]]$stacks <- as.list(stacks)
}
