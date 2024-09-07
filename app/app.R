
library(renv)

if(F){
  renv::init()
  devtools::install_github("https://github.com/curso-r/stockfish",force=T)
  devtools::install_github("https://github.com/jbkunst/rchess",force=T)
  devtools::install_github("https://github.com/almarch/shinyChess/tree/posit",force=T)
  renv::snapshot()
} else {
  renv::activate()
}

library(shinyChess)

app()
