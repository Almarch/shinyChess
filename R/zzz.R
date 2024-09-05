
.onLoad <- function(libname, pkgname) {
    resources <- system.file("www", package = "shinyChess")
    addResourcePath("www", resources)
}
