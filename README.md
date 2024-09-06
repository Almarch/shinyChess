# shinyChess

This is an app to play & study chess. It lies upon 3 powerful tools:

- The chess engine [chess.js](https://github.com/jhlywa/chess.js), wrapped into the R package [rchess](https://github.com/jbkunst/rchess). It ensures the game integrity.
- The chess solver [stockfish](https://github.com/official-stockfish/Stockfish). This is the AI that is used to analyse the parties and predict the next best move.
- The web framework [shiny](). It supports the user interface and allow for web deployment.

![image](https://github.com/user-attachments/assets/06abaedd-f033-48a4-b5d4-3ef62cda434b)

## Installation

### Installation as an R package

Only GNU/Linux OS is currently being supported due to the Stockfish compilation step.

Start by cloning the repository.

```sh
git clone https://github.com/almarch/shinyChess.git
```

The app uses [Stockfish](https://stockfishchess.org/). Make sure the submodule is properly fetched.

```sh
cd shinyChess
git submodule init
git submodule update
```

Also install all R depedencies. From R:

```r
install.packages(c("bsplus","shinyWidgets","shinyjs"))
install.packages('https://cran.r-project.org/src/contrib/Archive/rchess/rchess_0.1.tar.gz', repos = NULL, type = 'source')
install.packages('https://cran.r-project.org/src/contrib/Archive/stockfish/stockfish_1.0.0.tar.gz', repos = NULL, type = 'source')
install.packages('bigchess', version = '1.9.1')
```

shinyChess can then be installed.

```sh
R CMD INSTALL shinyChess
```

It may now be launched from R

```r
R -e "library(shinyChess); shinychess(port = 1997)"
```

The app now runs at http://127.0.0.1:1997/

### Installation with Docker

Install shinyChess without the need for an R environment using docker.

```sh
cd shinyChess
docker build -t chess .
```

The container can now be run:.

```sh
docker run -d -p 1997:80 chess
```

The app now runs at http://127.0.0.1:1997/

## Use

### Play and navigate the game

![image](https://github.com/user-attachments/assets/29c5f9d9-65d0-46a9-bb1f-aa4e3442c28c)

### Save and load parties as PGN



### Openings
![image](https://github.com/user-attachments/assets/16e9b028-05af-4a7b-8d06-baf537cdecf7)

### Game analysis


## License

This work is licensed under CC0 1.0 Universal.

Favicon: <a href="https://en.wikipedia.org/wiki/User:Cburnett" class="extiw" title="en:User:Cburnett">en:User:Cburnett</a> (knight); <a href="//commons.wikimedia.org/wiki/User:Francois-Pier" title="User:Francois-Pier">Francois-Pier</a> (zebra)<span class="int-own-work" lang="en"></span>, <a href="http://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-Share Alike 3.0">CC BY-SA 3.0</a>, <a href="https://commons.wikimedia.org/w/index.php?curid=48218187">Link</a>
