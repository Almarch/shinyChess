FROM rocker/shiny:4.4.1

RUN R -e "install.packages('bsplus', version = '0.1.4')"
RUN R -e "install.packages('shinyWidgets', version = '0.8.6')"
RUN R -e "install.packages('shinyjs', version = '2.1.0')"
RUN R -e "install.packages('htmlwidgets', version = '1.6.4')"
RUN R -e "install.packages('V8', version = '4.3.0')"
RUN R -e "install.packages('R6', version = '2.5.1')"
RUN R -e "install.packages('ggplot2', version = '3.5.1')"
RUN R -e "install.packages('plyr', version = '1.8.9')"
RUN R -e "install.packages('dplyr', version = '1.1.4')"
RUN R -e "install.packages('assertthat', version = '0.2.1')"
RUN R -e "install.packages('stringr', version = '1.5.1')"
RUN R -e "install.packages('processx', version = '3.8.0')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('bigchess', version = '1.9.1')"

RUN mkdir -p /app/shinyChess
ADD . /shinyChess

WORKDIR /

RUN R CMD INSTALL shinyChess

CMD R -e "library(shinyChess); app(shiny.port = 80, shiny.host = '0.0.0.0')"

EXPOSE 80
