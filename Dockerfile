FROM r-base:4.2.0

RUN mkdir -p /app/shinyChess
ADD ./shinyChess /app/shinyChess
ADD ./Stockfish/src/stockfish /app/

WORKDIR /app

RUN R -e "install.packages(c('shiny', 'rchess', 'stockfish', 'bigchess'))" \ 
    && R CMD INSTALL shinyChess

CMD R -e "library(shinyChess); shinychess(port = 80, host = '0,0,0,0', path.bin = '/app/stockfish')"

EXPOSE 80
