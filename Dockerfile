FROM r-base:4.2.0

RUN mkdir -p app/shinyChess
ADD * /app/shinyChess

WORKDIR /app

RUN R CMD INSTALL shinyChess

CMD R -e "library(shinyChess); shinychess(port = 80, host = '0,0,0,0')"

EXPOSE 80
