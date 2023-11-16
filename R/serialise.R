env <- new.env()
env$config <- list(
  tabs = list()
)

conf_tab_set <- \(id, title = "Title", description = "Description"){
  env$config$tabs[[id]] <- list(
    list(
      id = id,
      title = title,
      description = description,
      stacks = list()
    )
  )
}

conf_layout_set <- \(tab, config){
  env$config$tabs[[tab]]$layout <- config
}

conf_tab_set_stacks <- \(id, stacks) {
  env$config[[id]]$stacks <- as.list(stacks)
}

conf_get <- \(){
  return(env$config)
}

conf_serialise <- \(){
  conf_get() |>
    jsonlite::toJSON(
      dataframe = "rows",
      auto_unbox = TRUE,
      pretty = TRUE
    )
}
