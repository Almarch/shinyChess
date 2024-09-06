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