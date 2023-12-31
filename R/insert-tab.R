insert_tab <- \(
  id, 
  save, 
  saved, 
  title = tools::toTitleCase(id), 
  description = "Description",
  select = FALSE,
  nrows = 0L
){
  # insert the tab into the custom dashboard
  insert_sidebar_item(
    id,
    dashModuleUI(id, title, description, nrows = nrows)
  )

  conf_tab_set(id, title)

  if(select)
    select_sidebar_item(id)

  s <- dash_module_server(id, save)

  # nested observeEvent is ugly: to change
  observeEvent({s$stacks; s$layout}, { # nolint
    conf_layout_set(id, s$layout)
    conf_stacks_set(id, s$stacks)
    saved(!saved())
  }, ignoreInit = TRUE)

  mason(sprintf("#%s-grid", gsub(" ", "", id)))
}
