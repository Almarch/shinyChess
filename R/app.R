#' A Shiny application to play and study chess
#'
#'@name shinyChess
#'@param port The port to use for shiny, default is 1997
#'@export app
#'
#'

app = function(port = 1997,
                      host = "127.0.0.1"){

options(shiny.port = port,
	      shiny.host = host)

  ### load openings
  data("chessopenings")
  party.tmp = Chess$new()
  openings = c()
  for(nam in unique(chessopenings$name)){
    tmp = chessopenings$pgn[which(chessopenings$name == nam)]
    tmp = tmp[which.max(nchar(tmp))]
    party.tmp$load_pgn(tmp)
    openings[nam] = party.tmp$pgn()
  }
  openings = openings[which(unlist(lapply(openings, function(x) length(unlist(strsplit(x,split=" ",fixed=T))))) > 2)]

# load stockfish
  engine = fish$new(system.file("bin", "stockfish", package = "shinyChess"))
  engine$uci()

ui <- fluidPage(
  title = "Play & study chess",
  tags$head(
    tags$link(rel  = "icon shortcut",
              type = "image/png",
              href = "www/icon.png"), 
    tags$link(rel  = "stylesheet",
              type = "text/css",
              href = "www/styles.css"),
    # font
    tags$link(rel  = "preconnect",
              href = "https://fonts.googleapis.com"),
    tags$link(rel  = "preconnect",
              href = "https://fonts.gstatic.com",
              crossorigin = "anonymous"),
    tags$link(rel  = "stylesheet",
              href = "https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap")
  ),
  headerPanel(""),

  mainPanel(
    fluidRow(column(6,
      bsplus::bs_accordion(
            id = "game_info"
        ) |>
        bs_set_opts(
            panel_type = "warning"
        ) |>
        bs_append(
          title = "Portable game notation",
          content = fluidRow(
            column(8,textOutput("pgn_out")),
            column(4,
              fluidRow(actionBttn(
                inputId = "copy_pgn",
                label = "Copy", 
                style = "simple",
                color = "warning",
                width = "25px",
                icon = icon("scissors")
              )),
              br(),
              fluidRow(actionBttn(
                inputId = "paste_pgn",
                label = "Paste", 
                style = "simple",
                color = "warning",
                width = "25px",
                icon = icon("pencil")
              )),
            align="center"
            )
          )
        ) |>
        bs_append(
          title = "Openings",
          content = fluidRow(
            column(8,
              selectInput(inputId = "open",
                          label = "Openings:",
                          choices  = c("",names(openings)),
                          selected = "")
            ),
            column(4,
              br(),
              fluidRow(actionBttn(
                  inputId = "plop",
                  label = "Open", 
                  style = "simple",
                  color = "warning",
                  width = "25px",
                  icon = icon("book-open")
                ),
                align="center"
              )
            )
          )
        ) |>
        bs_append(
          title = "Analysis",
          content = column(12,
            fluidRow(
              column(6,
                numericInput("movetime", "Time/move (seconds):",value = 3),
                align = "center"
              ),
              column(6,
                br(),
                actionBttn(
                  inputId = "analysis_launch",
                  label = "Analysis", 
                  style = "simple",
                  color = "warning",
                  width = "35px",
                  icon = icon("fish")
                ),
                align="center"
              )
            ),
            fluidRow(plotOutput("analysis_along"))
          )
        )
    ),
    column(6,
      fluidRow(column(12,
          chessboardjsOutput('board', width = 300),
          align = "center"
      )),
      fluidRow(
        column(6,fluidRow(
          ## navigation
          actionBttn(
            inputId = "first",
            label = "", 
            style = "simple",
            color = "warning",
            width = "10px",
            icon = icon("backward")
          ),
          actionBttn(
            inputId = "pre",
            label = "", 
            style = "simple",
            color = "warning",
            width = "10px",
            icon = icon("caret-left")
          ),
          actionBttn(
            inputId = "nex",
            label = "", 
            style = "simple",
            color = "warning",
            width = "10px",
            icon = icon("caret-right")
          ),
          actionBttn(
            inputId = "last",
            label = "", 
            style = "simple",
            color = "warning",
            width = "10px",
            icon = icon("forward")
          )),
          align = "center"
        ),
        column(6,
          fluidRow(
            column(8,
              selectInput(
                inputId = "move",
                label = NULL,
                choices  = c(""),
                selected = ""
              )
            ),
            column(4, uiOutput("play"))
          )
        )
      )
    ))
  )
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

  output$play = renderUI(
    actionButton(
      inputId = "play",
      label = "Play",
      class = "white-btn"
    )
  )
  
  ### play opening
  observeEvent(input$plop, {
    if(input$open != ""){
      values[["party"]]$load_pgn(openings[input$open])
    }
    values[["track"]] = values[["party"]]$pgn()
    values[["cp"]] = c()
    values[["bestmove"]] = c()
    values[["Analyzed"]] = NULL
    
    updateSelectInput(session,
                      inputId = "move",
                      label = NULL,
                      choices = c("",values[["party"]]$moves()),
                      selected = "")
    output$play = renderUI(
      actionButton(
      inputId = "play",
          label = "Play",
          class = c(w="white-btn",b="black-btn")[values[["party"]]$turn()]
        )
      )
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
    
  updateSelectInput(session,
                    inputId = "move",
                    label = NULL,
                    choices = c("",values[["party"]]$moves()),
                    selected = "")
  output$play = renderUI(
    actionButton(
    inputId = "play",
        label = "Play",
        class = c(w="white-btn",b="black-btn")[values[["party"]]$turn()]
      )
    )
  })
}

# launch shiny

shinyApp(ui, server)

}
