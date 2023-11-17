env <- new.env()
env$config <- list(
  tabs = list()
)

conf_tab_set <- \(id, title = "Title", description = "Description"){
  env$config$tabs[[id]]$id <- id
  env$config$tabs[[id]]$title <- title
  env$config$tabs[[id]]$description <- description
}

conf_layout_set <- \(tab, config){
  env$config$tabs[[tab]]$layout <- config
}

conf_stacks_set <- \(id, stacks) {
  env$config$tabs[[id]]$stacks <- stacks
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

conf_restore <- \(conf, save, saved) {
  lapply(conf$tabs, \(tab) {
    print(tab)

    insert_tab(
      tab$id, 
      save, 
      saved, 
      tab$title, 
      tab$description,
      nrows = length(tab$layout$grid)
    )
    
    masonry_restore_config(sprintf("%s-%s-grid", tab$id, gsub(" ", "", tab$id)), tab$layout)
  })
}
