
install.packages('bsplus', version = '0.1.4')
install.packages('shinyWidgets', version = '0.8.6')
install.packages('shinyjs', version = '2.1.0')
install.packages('htmlwidgets', version = '1.6.4')
install.packages('V8', version = '4.3.0')
install.packages('R6', version = '2.5.1')
install.packages('ggplot2', version = '3.5.1')
install.packages('plyr', version = '1.8.9')
install.packages('dplyr', version = '1.1.4')
install.packages('assertthat', version = '0.2.1')
install.packages('stringr', version = '1.5.1')
install.packages('processx', version = '3.8.0')
install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')
install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')
install.packages('bigchess', version = '1.9.1')

devtools::install_github("https://github.com/Almarch/shinyChess/tree/posit")

library(shinyChess)

app()
