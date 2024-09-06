# <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Chess_Zdt45.svg/45px-Chess_Zdt45.svg.png?20170728103323" width = "50px" /> shinyChess

This is an app to play & study chess. It lies upon powerful tools:

- The chess library [rchess](https://github.com/jbkunst/rchess), that wraps:
    - the chess engine [chess.js](https://github.com/jhlywa/chess.js). It ensures the game playability and rules integrity.
    - the chess graphical board [chessboardjs](https://github.com/oakmac/chessboardjs). The board design comes from there.
- The chess solver [stockfish](https://github.com/official-stockfish/Stockfish). This is the AI that is used to analyse the parties and predict the next best move.
- The web framework [shiny](https://github.com/rstudio/shiny). It supports the user interface and allow for web deployment.

<div align="center">
<div style="
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    margin: auto;
">
    <img src="https://github.com/user-attachments/assets/3c73d0fe-169c-49da-84d0-8f5e330bd9ec" alt="chessboardjs"  width="200px">
    <img src="https://stockfishchess.org/images/logo/icon_512x512@2x.png" alt="stockfish"  width="200px">
    <img src="https://camo.githubusercontent.com/b1bcd1d17cbe316d92317dbdcfead95a3fef02332b2ac8333ea09bd91365d74e/68747470733a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f7468756d622f622f62662f5368696e795f6865785f6c6f676f2e7376672f38303070782d5368696e795f6865785f6c6f676f2e7376672e706e67" alt="Shiny"  width="170px">
</div>
</div>

## Installation

### Installation with Docker

<img src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Docker_%28container_engine%29_logo_%28cropped%29.png" width="120px" align="right"/>

Install shinyChess without the need for an R environment using Docker. Installation with Docker can be performed from GNU/Linux or Windows.

```sh
git clone --recurse-submodules https://github.com/almarch/shinyChess.git
cd shinyChess
docker build -t chess .
```

The container can now be launched with Docker.

```sh
docker run -d -p 1997:80 chess
```

The app now runs at http://127.0.0.1:1997/

### Installation as an R package

<img src="https://camo.githubusercontent.com/b89c3467bd2fb1ed2452237329f6974aec62c88eb423cde6429aad2a8f2383a1/68747470733a2f2f6372616e2e722d70726f6a6563742e6f72672f526c6f676f2e737667" width="80px" align="right"/>

Installation as an R package can only be performed on GNU/Linux because of the Stockfish compilation step.

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

It may now be launched from R:

```r
library(shinyChess)
app(port = 1997)
```

The app now runs at http://127.0.0.1:1997/

## Deployment

### On your own server

 Have a look to [<img src="https://github.com/Almarch/tamaR/raw/main/inst/www/icon.png" alt="tamaR" width="20"/> this project ](https://github.com/Almarch/tamaR?tab=readme-ov-file#4-web-deployment) for web deployment.

### On Posit Cloud

<img src="https://docs.posit.co/images/product-icons/posit-icon-fullcolor.png" width="80px" align="right"/>

A demo version is kindly hosted on [Posit Cloud](https://posit.co) at [<img src="inst/www/icon.png" width = "20px" /> this adress](https://shinyapps.io/almarch/shinyChess). Deployment on the Posit Cloud is realized from RStudio using `app/app.R`

## Use

### Play and navigate the game

![image](https://github.com/user-attachments/assets/29c5f9d9-65d0-46a9-bb1f-aa4e3442c28c)

### Save and load PGNs

### Openings
![image](https://github.com/user-attachments/assets/16e9b028-05af-4a7b-8d06-baf537cdecf7)

### Game analysis

![image](https://github.com/user-attachments/assets/06abaedd-f033-48a4-b5d4-3ef62cda434b)

## License

This work is licensed under CC0 1.0 Universal.

Favicon: <a href="https://en.wikipedia.org/wiki/User:Cburnett" class="extiw" title="en:User:Cburnett">en:User:Cburnett</a> (knight); <a href="//commons.wikimedia.org/wiki/User:Francois-Pier" title="User:Francois-Pier">Francois-Pier</a> (zebra)<span class="int-own-work" lang="en"></span>, <a href="http://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-Share Alike 3.0">CC BY-SA 3.0</a>, <a href="https://commons.wikimedia.org/w/index.php?curid=48218187">Link</a>
