#' Export data stage for Syberia model process.
#'
#' @param export_options list. The available export options. Will differ
#'    depending on the adapter. (default is file adapter)
#' @export
export_stage <- function(export_options) {
  if (!is.list(export_options)) # Coerce to a list using the default adapter
    export_options <- setNames(list(resource = export_options), default_adapter())

  build_export_stagerunner(export_options)
}

#' Build a stagerunner for exporting data with backup sources.
#'
#' @param export_options list. Nested list, one adapter per list entry.
#'   These adapter parametrizations will get converted to legitimate
#'   IO adapters. (See the "adapter" reference class.)
build_export_stagerunner <- function(export_options) {
  stages <- lapply(seq_along(export_options), function(index) {
    adapter <- names(export_options)[index] %||% default_adapter()
    adapter <- fetch_adapter(adapter)
    opts <- export_options[[index]]

    function(modelenv) {
      attempt <- adapter$write(modelenv$model_stage$model, opts)
    }
  })
  names(stages) <- vapply(stages, function(stage)
    paste0("Export to ", environment(stage)$adapter$.keyword), character(1))

  stages
}

