#' custom_transform
#'
#' A new transform block.
#'
#' @export
custom_transform_block <- function(data, ...) {
  fields <- list(
    n_rows = new_numeric_field(10, 10, nrow(data))
  )

  new_block(
    fields = fields,
    expr = quote({
      data[sample(.(n_rows)),]
    }),
    ...,
    class = c("custom_transform_block", "transform_block")
  )
}

x <- 1L
