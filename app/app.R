
install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')
install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')

devtools::install_github("https://github.com/Almarch/shinyChess/tree/posit")

library(shinyChess)

app()
