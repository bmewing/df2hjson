#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dndTree <- function(json, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'dndTree',
    x,
    width = width,
    height = height,
    package = 'dndTree'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
dndTreeOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'dndTree', width, height, package = 'dndTree')
}

#' Widget render function for use in Shiny
#'
#' @export
renderDndTree <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, dndTreeOutput, env, quoted = TRUE)
}
