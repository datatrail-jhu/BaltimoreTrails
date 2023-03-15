#' @export
runDataApp <- function() {
  appDir <- system.file("shiny-examples", "myapp.R", package = "BaltimoreTrails")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `BaltimoreTrails`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
