insert_tab <- \(
  id, 
  save, 
  saved, 
  title = tools::toTitleCase(id), 
  description = "description",
  select = FALSE
){
  # insert the tab into the custom dashboard
  insert_sidebar_item(
    id,
    dashModuleUI(id, title, description)
  )

  conf_tab_set(id, title)

  if(select)
    select_sidebar_item(id)

  s <- dash_module_server(id, save)

  # nested observeEvent is ugly: to change
  observeEvent(s(), {
    conf_layout_set(id, s())
    saved(!saved())
  }, ignoreInit = TRUE)

  mason(sprintf("#%s-grid", gsub(" ", "", id)))
}
