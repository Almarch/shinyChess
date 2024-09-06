
install.packages('bsplus', version = '0.1.4', repos = "https://cran.biotools.fr/")
install.packages('shinyWidgets', version = '0.8.6', repos = "https://cran.biotools.fr/")
install.packages('shinyjs', version = '2.1.0', repos = "https://cran.biotools.fr/")
install.packages('htmlwidgets', version = '1.6.4', repos = "https://cran.biotools.fr/")
install.packages('V8', version = '4.3.0', repos = "https://cran.biotools.fr/")
install.packages('R6', version = '2.5.1', repos = "https://cran.biotools.fr/")
install.packages('ggplot2', version = '3.5.1', repos = "https://cran.biotools.fr/")
install.packages('plyr', version = '1.8.9', repos = "https://cran.biotools.fr/")
install.packages('dplyr', version = '1.1.4', repos = "https://cran.biotools.fr/")
install.packages('assertthat', version = '0.2.1', repos = "https://cran.biotools.fr/")
install.packages('stringr', version = '1.5.1', repos = "https://cran.biotools.fr/")
install.packages('processx', version = '3.8.0', repos = "https://cran.biotools.fr/")
install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')
install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = "https://cran.biotools.fr/", type = 'source')
install.packages('bigchess', version = '1.9.1', repos = "https://cran.biotools.fr/")

devtools::install_github("https://github.com/Almarch/shinyChess/tree/posit")

library(shinyChess)

app()
