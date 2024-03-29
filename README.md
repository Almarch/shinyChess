# shinyChess

The purpose of this app is to provide a shiny interface to play and study chess.

![Screenshot from 2023-09-29 16-28-17](https://github.com/Almarch/shinyChess/assets/13364928/6dcfedc7-2369-4f4d-a026-101ca7597965)

## Dependencies

The app is designed to work on Linux and Windows environments. It uses 2 powerful libraries:

- rchess (https://cran.r-project.org/web/packages/rchess/index.html), that wrapes the chess.js engine (https://github.com/jhlywa/chess.js) into R along with a collection of openings and a neat graphical board.
- stockfish (https://stockfishchess.org/), the reference chess AI that is connected to R via the homonymous package (https://cran.r-project.org/web/packages/stockfish/index.html).

All the following dependencies should be installed via R:

```
> install.packages(c("shiny","shinyjs","stockfish","rchess","bigchess"))
```

And the stockfish binary file should be available.

## Launch

ShinyChess is a shiny app and can be launched from R using the ```source()``` command, from RStudio using the "Run App" button, or as a command line:
```
$ R -e "shiny::runApp('~/.../shinyChess')"
```

It starts with 2 disabled action buttons: "Open" and "Analysis".
- To enable "Open", click "Load openings". This will load the opening collection provided with the rchess package and run a pre-processing.
- To enable "Analysis", click "Browse..." and load the stockfish binary file.

## Use

ShinyChess uses the portable game notation (PGN). The playable text area can process one or several PGN instructions, up to a whole party. /!\ Turn identifiers such as "1." are accepted but must be separated from the moves with a space (e.g. "1. e4" not "1.e4") ; checks and checkmates must be notified (respectively "+" and "#") ; comments (such as "?" or "!") are not accepted. The party is recorded as a text to ease archiving. A checkbox allows listing all possible moves (it signals checks an checkmates).

A series of action buttons are available:
- "Move" plays the instruction(s) in the playable text area.
- "Open" plays the opening if an opening has been selected in the corresponding dropdown list.
- "Analysis" processes each move of the party using stockfish, with a dedicated time / move that is provided in the corresponding box.
- The navigation arrows allow a move-by-move exploration of the party, for the board visualization as well as for the analysis plot.

![Screenshot from 2023-09-29 16-27-55](https://github.com/Almarch/shinyChess/assets/13364928/8c577803-e4b0-47c3-bd61-516137649082)

The analysis plot takes all analyzed moves as x and the advantage in centipawn (cp) as y on a sigmoid scale. A positive value is an advantage for White and a negative value is an advantage for Black. The vertical red line identifies the current move. On top, the exact advantage and the best next move are displayed. The plot starts at move 0, with the best first move for White to open the party.
