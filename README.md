# shinyChess

The purpose of this app is to provide a shiny interface to play and study chess.

![Screenshot from 2023-09-29 16-28-17](https://github.com/Almarch/shinyChess/assets/13364928/6dcfedc7-2369-4f4d-a026-101ca7597965)

## Installation

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
install.packages(c("bsplus","shinyWidgets"))
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

## Deployment

Check out [shinyGotchi project](https://github.com/almarch/shinyGotchi) for a step⁻by-step deployment as a web app.

shinyGotchi's port has been defined at 1996 and shinyChess's at 1997 because these are 2 pivotal dates for these games respectively and for the global perception of AI in its broadest sense.

## Use

ShinyChess uses the portable game notation (PGN). The playable text area can process one or several PGN instructions, up to a whole party. Turn identifiers such as "1." are accepted but must be separated from the moves with a space (e.g. "1. e4" not "1.e4") ; checks and checkmates must be notified (respectively "+" and "#") ; comments (such as "?" or "!") are not accepted. The party is recorded as a text to ease archiving. A checkbox allows listing all possible moves (it signals checks an checkmates).

A series of action buttons are available:
- "Move" plays the instruction(s) in the playable text area.
- "Open" plays the opening if an opening has been selected in the corresponding dropdown list.
- "Analysis" processes each move of the party using stockfish, with a dedicated time / move that is provided in the corresponding box.
- The navigation arrows allow a move-by-move exploration of the party, for the board visualization as well as for the analysis plot.

![Screenshot from 2023-09-29 16-27-55](https://github.com/Almarch/shinyChess/assets/13364928/8c577803-e4b0-47c3-bd61-516137649082)

The analysis plot takes all analyzed moves as x and the advantage in centipawn (cp) as y on a sigmoid scale. A positive value is an advantage for White and a negative value is an advantage for Black. The vertical red line identifies the current move. On top, the exact advantage and the best next move are displayed. The plot starts at move 0, with the best first move for White to open the party.


## License

This work is licensed under CC0 1.0 Universal.

Favicon: <a href="https://en.wikipedia.org/wiki/User:Cburnett" class="extiw" title="en:User:Cburnett">en:User:Cburnett</a> (knight); <a href="//commons.wikimedia.org/wiki/User:Francois-Pier" title="User:Francois-Pier">Francois-Pier</a> (zebra)<span class="int-own-work" lang="en"></span>, <a href="http://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-Share Alike 3.0">CC BY-SA 3.0</a>, <a href="https://commons.wikimedia.org/w/index.php?curid=48218187">Link</a>
