
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
#if(Sys.info()["sysname"] == "Linux") system(paste0("chmod +x ",path.bin))
#engine = fish$new(path.bin)
#engine$uci()
