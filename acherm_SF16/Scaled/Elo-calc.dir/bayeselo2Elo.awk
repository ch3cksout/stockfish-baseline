#!/usr/bin/gawk -f
# calculate absolute Elo from bayeselo_ratings.txt
# required input parameters: -v anchor_player=*name* -v anchor_Elo=*value*

(FNR==1){ # header line
	for (i=1; i<=NF; i++){
		if ($i=="Name") column_Name=i 
		if ($i=="Elo") column_Elo=i 
	}
	print $0
	delete out_lines
}

(FNR>1){
	NF_out_lines[FNR]=NF
	for (i=1; i<=NF; i++){
		out_lines[FNR,i]=$i
		if ($column_Name==anchor_player) anchor_offset=$column_Elo 
	}
}

ENDFILE{
	for (line=2; line<=FNR; line++){
		out=""
		out_lines[line,column_Elo] += anchor_Elo-anchor_offset
		for (i=1; i<=NF_out_lines[line]; i++){
			out=out "\t" out_lines[line,i] 
		}
		print out
	}
}
