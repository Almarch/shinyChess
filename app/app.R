
install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = NULL, type = 'source')
install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = NULL, type = 'source')
install.packages('bigchess', version = '1.9.1')

devtools::install_github("https://github.com/Almarch/shinyChess")

library(shinyChess)

app()