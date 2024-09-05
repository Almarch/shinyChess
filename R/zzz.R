### www & bin repo
.onLoad <- function(libname, pkgname) {
    addResourcePath("www", system.file("www", package = "shinyChess"))
    addResourcePath("bin", system.file("bin", package = "shinyChess"))
}

