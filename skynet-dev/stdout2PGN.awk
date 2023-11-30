#!/usr/bin/gawk -f
# by ch3cksout@skiff.com
# extract PGNs from 'checkmate.py' output 

BEGIN {
    RS = "\n"
}

#{print "TRACK $0: " $0}


/\[Event /{
	split("", pgn_lines)
	n_pgn_lines=0
	pgn_lines[++n_pgn_lines]=$0
	game_termination=""
}

/ \[/{
	sub(/^ */,"")
	pgn_lines[++n_pgn_lines] = $0
}

/\[White/{
	 White_player=$0
	 sub(/"\]/,"",White_player)
	 sub(/.*"/,"",White_player)
	 index_White=n_pgn_lines
}		

/\[Black/{
	 Black_player=$0
	 sub(/"]/,"",Black_player)
	 sub(/.*"/,"",Black_player)
	 index_Black=n_pgn_lines
}

/"gpt/{
	 sub(/ ".*]/,"")
	 sub(/.*\[/,"")
	 gpt_color=$0
	 #print "TRACK gpt_color="gpt_color
	 index_gpt=n_pgn_lines
}

/"Stockfish/{
	 sub(/ ".*]/,"")
	 sub(/.*\[/,"")
	 Stockfish_color=$0
	 #print "TRACK Stockfish_color="Stockfish_color
	 index_Stockfish=n_pgn_lines
}

/\[Result/{
	 index_Result=n_pgn_lines
}

!/!$/{
	sub(/^ */,"")
	store_line=$0 # gametext here
}

/Stockfish.* won.*!/{
	result[Stockfish_color]="1"
	result[gpt_color]="0"
	game_termination= result["White"] "-" result["Black"]
}

/GPT.* won.*!/{
	result[Stockfish_color]="0"
	result[gpt_color]="1"
	game_termination= result["White"] "-" result["Black"]
}

/Draw!/{
	game_termination="1/2-1/2"
}

/!$/{
	#for (i in result) print "TRACK result["i"]=" result[i]
	pgn_lines[index_Result]="[Result \"" game_termination "\"]"
	for (i=1; i<n_pgn_lines; i++) {
		print pgn_lines[i]
	}
	print store_line
	print "{" $0 "}" 
	print game_termination " \n"
}

