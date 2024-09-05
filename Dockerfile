FROM rocker/shiny:4.4.1

RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = NULL, type = 'source')"
RUN R -e "install.packages('bigchess', version = '1.9.1')"

RUN mkdir -p /app/shinyChess
ADD ./shinyChess /app/shinyChess
ADD ./Stockfish/src/stockfish /app/

WORKDIR /app

RUN R CMD INSTALL shinyChess

CMD R -e "library(shinyChess); shinychess(port = 80, host = '0,0,0,0')"

EXPOSE 80
