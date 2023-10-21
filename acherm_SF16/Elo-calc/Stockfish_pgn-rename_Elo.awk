#!/usr/bin/gawk -f
# script to append Stockfish ELo to its name in PGN
BEGIN {
	#print "Running of the script:", ENVIRON["_"]
}

/\[Site /{ #chessgpt@skiff.com: localhost, appended Stockfish ELo to its name
	$0 = "[Site \"chessgpt@skiff.com: localhost, appended Stockfish ELo to its name\"]"
}

/\[White /{
	#print "TRACK White $2='"$2"'"
	WhitePlayerLine=FNR
	WhitePlayer=$2
	gsub(/["\]]/, "", WhitePlayer)
	#print "TRACK WhitePlayer='"WhitePlayer"'"
}

/\[Black /{
	#print "TRACK Black $2='"$2"'"
	BlackPlayerLine=FNR
	BlackPlayer=$2
	gsub(/["\]]/, "", BlackPlayer)
	#print "TRACK BlackPlayer='"BlackPlayer"'"
}

/\[WhiteElo /{
	if (WhitePlayer=="Stockfish") {
		WhiteElo=$2
		gsub(/["\]]/, "", WhiteElo)
		WhitePlayer=WhitePlayer "_Elo" WhiteElo
		lines[WhitePlayerLine]="[White \""WhitePlayer"\"]"
		#print "TRACK WhitePlayer='"WhitePlayer"'"
	}
}

/\[BlackElo /{
	if (BlackPlayer=="Stockfish") {
		BlackElo=$2
		gsub(/["\]]/, "", BlackElo)
		BlackPlayer=BlackPlayer "_Elo" BlackElo
		lines[BlackPlayerLine]="[Black \""BlackPlayer"\"]"
		#print "TRACK BlackPlayer='"BlackPlayer"'"
	}
}

{
	lines[FNR]=$0
}

ENDFILE { #
	for (i=1; i<=FNR; i++) {	
		print lines[i]
	}
	#print "TRACK FNR='"FNR"'"
	print ""
	delete lines
}

