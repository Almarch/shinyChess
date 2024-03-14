#' A Shiny application to play and study chess
#'
#'@name shinyChess
#'@param port The port to use for shiny, default is 1997
#'@export shinychess
#'
#'

shinychess = function(port = 1997, host = "127.0.0.1"){

options(shiny.port = port,
	      shiny.host = host)

ui <- fluidPage(
  tags$head(
		  tags$link(rel = "icon shortcut",
			          type="image/png",
			          href = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAAsSAAALEgHS3X78AAAAAXNSR0IArs4c6QAAAkpJREFUOE+l009IFFEcwPHv7M7MpvvPQiz2spR6EDNRIRGJMVgLobC0gxnd+h9REKVR3TPoEEQSJQYR1EGKssQWIsMO1clOBRFKhVRkbrk7s7vzJ95sba6ypx4M82bm9z6/3294T5p/98jhP4a0FHAkGcc2sVFIZEspkxN4PcUzFACmafHmE/h8CqtCJVwdHqH/cBd+b6qoUAAkUwZPp+a492CMtjaN8fEn7OzcTnNDNZGQhYcs0hKqANBNmZv3XzP6eAxFUdzQqqoqAoEAleuidMc2UOLRkaR/TB4wLZtX7w0GLl1B0zTi8bgb6PF4CAaD1NbWEgr6OdSjoaLn63ABx3FYsIMcP3eZ2dlZ/H4/iUQiH2SapovU19fTsrGBLU0VyN5cFS6QMW1Gnn1g8NoQtm27WUV2cQlcAGJeV1fnzgfOH2GlmszFCOBnxse+kxeZnp4uWCgqMQwDy7Ly1bS3t7O+ppoubS2q4kWaezvqfJ6X6d1/ilAo5LYQjUbZ09NNecUa+vrPuoCoRGRsbW11ny/07SWgmn+A7xkGBkeYmHjulnniYC+lKty4G2dy8oXblgDEEFU1NjZy+uhuImEr18KPxAIzXw2+zGcpD/tYHVYYfznD9aFhtwUx/gLiLtrY0aHRUlOWA8RL3ciwkEyhqgofEz4OHDuDruv5hYv3TywWY1NLEx3NkRyw+KORNhl+OMWt23eKbt9IJELntq3s2ly5HEjpaWa+ZfmVTFPsmIqfWRZQiFasWA6IdtKZLOJgFQUARZFRFZnfbCIYoijfUngAAAAASUVORK5CYII=")
  ),
  headerPanel(""),

  sidebarPanel(
    
    ### actions
    textInput("move", "Play (white):"),
    actionButton("play", "Move"),
    actionButton("plop", "Open"),
    actionButton("analysis_launch","Analysis"),
    
    ## pgn
    textOutput("pgn_out"),
    
    ## possible moves
    checkboxInput("show_moves", "Show all possible moves",F),
    textOutput("possible_moves"),
    
    ## navigation
    actionButton("first", "<<"),
    actionButton("pre"  , "<" ),
    actionButton("nex"  , ">" ),
    actionButton("last" , ">>"),
    
    ## openings
   selectInput(inputId = "open",
                          label = "Openings:",
                          choices  = c("",names(openings)),
                          selected = ""),

    ## analysis
    numericInput("movetime", "Analysis (sec/move):",value = 5),
    br()
  ),

  mainPanel(
    chessboardjsOutput('board', width = 300),
    plotOutput("analysis_along")
  ),
)

server <- function(input, output, session) {
  
  # functions
  simplify_pgn = function(pgn){
    pgn = gsub(pgn,pattern = "\n", replacement = " ",fixed=T)
    pgn = gsub(pgn,pattern = "\"", replacement = " ",fixed=T)
    pgn = unlist(strsplit(pgn,split=" ",fixed = T))
    pgn = pgn[!grepl(x = pgn,pattern = ".",fixed = T)]
    return(pgn)
  }
  eval2cp = function(x){
    x = x[grep(x = x,pattern = "Final evaluation")]
    x = unlist(strsplit(x,split=" ",fixed=T))
    x = x[which(x != "")]
    x = x[3]
    x = as.numeric(x)
    return(x)
  }
  eval2bestmove = function(x){
    x = x[grep(x = x,pattern = "bestmove")]
    x = unlist(strsplit(x,split=" ",fixed=T))
    x = x[which(x != "")]
    x = x[2]
    return(x)
  }
  sig = function(x){
    ytmp = 0.9
    xtmp = 4
    a = -log(2/(ytmp+1) - 1)/xtmp
    y = (2/(1 + exp(-a*x))) - 1
    return(y)
  }

  ### init

  values <- reactiveValues()
  values[["party"]] = Chess$new()  # the current position and Chess item
  values[["track"]] = ""     # the temporary track in which the player currently is
  values[["cp"]] = c()
  values[["bestmove"]] = c()
  values[["Analyzed"]] = NULL
  values[["nmoves"]] = NULL
  
  ### play opening
  observeEvent(input$plop, {
    if(input$open != ""){
      values[["party"]]$load_pgn(openings[input$open])
    }
    values[["track"]] = values[["party"]]$pgn()
    values[["cp"]] = c()
    values[["bestmove"]] = c()
    values[["Analyzed"]] = NULL
    
    updateTextInput(session,
                    inputId = "move",
                    label = paste0("Play (",c(w="white",b="black")[values[["party"]]$turn()],"):"),
                    value = "")
  })
  
  ### play
  observeEvent(input$play, {
    
    if(!is.null(values[["Analyzed"]])) {
      values[["Analyzed"]] <- 0:length(simplify_pgn(values[["party"]]$pgn()))
      values[["cp"]] = values[["cp"]][values[["Analyzed"]]+1]
      values[["bestmove"]] = values[["bestmove"]][values[["Analyzed"]]+1]
    }
    
    mov = simplify_pgn(input$move)
    i = 1
    while(mov[i] %in% values[["party"]]$moves()){
      values[["party"]]$move(mov[i])
      i = i+1
    }
    values[["track"]] = values[["party"]]$pgn()
  })
  
  ### analysis
  observeEvent(input$analysis_launch, {
    
    if(is.null(values[["Analyzed"]])) {
      
      engine$ucinewgame()
      engine$run("position startpos")
      engine$go(movetime = input$movetime*1e3)
      Sys.sleep(input$movetime+0.5)
      eval = engine$run("eval")
      
      values[["Analyzed"]] = 0
      values[["cp"]] = eval2cp(eval)
      bm = eval2bestmove(eval)
      bm = simplify_pgn(lan2san(bm))
      values[["bestmove"]] = bm[length(bm)]
    }
    
    pgn = gsub(x = values[["track"]], pattern ="\n", replacement =" ")
    
    if(pgn != "") {
      uci = unlist(strsplit(san2lan(pgn),split=" ", fixed=T))
      toAnalyze = 1:length(uci)
      
      for(i in toAnalyze[which(!(toAnalyze %in% values[["Analyzed"]]))]){
        engine$run(paste0("position startpos moves ", paste(uci[1:i],collapse=" ")))
        engine$go(movetime = input$movetime*1e3)
        Sys.sleep(input$movetime+0.5)
        eval = engine$run("eval")
        
        values[["Analyzed"]] = c(values[["Analyzed"]],i)
        values[["cp"]] = c(values[["cp"]],eval2cp(eval))
        bm = eval2bestmove(eval)
        bm = simplify_pgn(lan2san(paste(c(uci[1:i],bm),collapse=" ")))
        values[["bestmove"]] = c(values[["bestmove"]],bm[length(bm)])
      }
    }
  })
  
  ### navigation
  observeEvent(input$first, {
    values[["party"]]$initialize()
  })
  
  observeEvent(input$last, {
    values[["party"]]$load_pgn(values[["track"]])
  })
  
  observeEvent(input$pre, {
    if(values[["party"]]$pgn() != ""){
      tmp = simplify_pgn(values[["party"]]$pgn())
      tmp = paste(tmp[0:(length(tmp) - 1)],collapse=" ")
      values[["party"]]$load_pgn(tmp)
    }
  })
  
  observeEvent(input$nex, {
    if(values[["party"]]$pgn() != values[["track"]]){
      tmp1 = simplify_pgn(values[["party"]]$pgn())
      tmp2 = simplify_pgn(values[["track"]])
      values[["party"]]$load_pgn(paste(tmp2[1:(length(tmp1) + 1)],collapse=" "))
    }
  })
  
  ### whatever action is made, plot the board & update the turn
  observeEvent(input$play  |
                 input$plop  |
                 input$first |
                 input$pre   |
                 input$nex   |
                 input$last, {
                   
                   output$board <- renderChessboardjs({
                     chessboardjs(values[["party"]]$fen())
                   })
                   
                   values[["nmoves"]] = length(simplify_pgn(values[["party"]]$pgn()))
                   
                   output$analysis_along <- renderPlot({
                     if(length(values[["cp"]])>0) {
                       nmax = values[["Analyzed"]][length(values[["Analyzed"]])]
                       plot(values[["Analyzed"]],
                            sig(values[["cp"]]),
                            ylim = c(-1,1),
                            axes = F,
                            type = "n",
                            xlab = "",
                            ylab = "",
                            main = if(values[["nmoves"]] <= nmax) paste0("cp: ",
                                                                         values[["cp"]][values[["nmoves"]]+1],
                                                                         ", best move: ",
                                                                         values[["bestmove"]][values[["nmoves"]]+1]) else "-")
                       box()
                       axis(side = 1, at = values[["Analyzed"]])
                       axis(side = 2,
                            at = c(sig(c(-4,-2,-1,0,1,2,4))),
                            labels =   c(-4,-2,-1,0,1,2,4))
                       polygon(x = c(-10,-10,rep(length(values[["cp"]])+10,2)),
                               y = c(-2,0,0,-2),
                               col="black")
                       lines(0:(length(values[["cp"]])-1),
                             sig(values[["cp"]]),
                             col="grey",lwd=3)
                       abline(v = values[["nmoves"]],
                              col = "red",
                              lwd = 3)
                     } else {
                       plot(0,0,axes=F,xlab="",ylab="",main="",type="n")
                     }
                   })
                   
                   updateSelectInput(session,
                                     inputId = "open",
                                     label = "Opening:",
                                     choices  = c("",
                                                  names(openings)),
                                     selected =
                                       if(values[["party"]]$pgn() %in% openings)
                                         names(openings)[which(openings == values[["party"]]$pgn())] else ""
                   )
                   
                   ### save
                   output$pgn_out <- renderText({
                     return(values[["party"]]$pgn())
                   })
                   
                   output$possible_moves <- renderText({
                     if(!input$show_moves) {
                       return("")
                     } else {
                       return(values[["party"]]$moves())
                     }
                   })
                   
                   updateTextInput(session,
                                   inputId = "move",
                                   label = paste0("Play (",c(w="white",b="black")[values[["party"]]$turn()],"):"),
                                   value = "")
                 })
}

# launch shiny

shinyApp(ui, server)

}
