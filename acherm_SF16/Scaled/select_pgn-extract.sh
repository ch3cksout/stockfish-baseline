#!/bin/bash
# comments from ~/repos/stockfish-baseline/acherm_SF16/Unscaled/

S="("
for F in $(ls Run*/*.pgn)
do 
	S=$(echo -n $S $(grep -c Event $F ) " + ")
done
S=$(echo -ne $S "0)\n" )
name_all=Total_$(echo $S |bc -l)_Games

/opt/chess/bayeselo2Elo.awk -v anchor_player="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -v anchor_Elo=1785 \
 '${name_all}.pgn.bayeselo_ratings.txt' > '${name_all}.pgn.bayeselo_ratings-Elo.txt'

ordo --white-auto --draw-auto --average=1785 --anchor="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" \
 -p ${name_all}.pgn -o ${name_all}.ordo.txt -g ${name_all}.ordo-g.txt 

echo '$name_all=' $name_all
pgn-extract \
Run1/acherm_SF16-match_cutechess.sh_result.pgn \
Run2/acherm_SF16-match_cutechess.sh_result.pgn \
Run3/acherm_SF16-match_cutechess.sh_result.pgn \
Run4B/acherm_SF16-match_cutechess.sh_result.pgn \
Run5A/acherm_SF16-match_cutechess.sh_result.pgn \
Run5B/acherm_SF16-match_cutechess.sh_result.pgn \
Run5C/acherm_SF16-match_cutechess.sh_result.pgn \
Run5D/acherm_SF16-match_cutechess.sh_result.pgn \
Run5E/acherm_SF16-match_cutechess.sh_result.pgn \
Run6/acherm_SF16-match_cutechess.sh_result.pgn \
Run7/acherm_SF16-match_cutechess.sh_result.pgn \
Run8/acherm_SF16-match_cutechess.sh_result.pgn \
 --output "${name_all}.pgn"

/opt/chess/bayeselo.sh "${name_all}.pgn"

<<'COMMENT'
ls -1 Run*/acherm_SF16-match_cutechess.sh_result.pgn

for F in $(ls Run*/*.pgn)
do 
	grep -c Event $F 
done

for F in $(ls Run*/*.pgn)
do 
	echo -e $F \\ >>$0 
done

#=
320
320
240
192
100
100
32
100
1000
3192
3000
1000

COMMENT
# BEWARE not to  trash original PGNs!
<<'COMMENT'
#= ...

/opt/chess/bayeselo2Elo.awk -v anchor_player="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -v anchor_Elo=1785 \
 '${name_all}.pgn.bayeselo_ratings.txt' > '${name_all}.pgn.bayeselo_ratings-Elo.txt'

ordo --white-auto --draw-auto --average=1785 --anchor="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -p ${name_all}.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 
ordo  -p ${name_all}.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt -g ordo_g_white-auto

sed -e "s/-Copy[1-9]//" ${name_all}.pgn > SF16-tournaments_32+20+18+2x160_Copies-merged.pgn

/opt/chess/bayeselo.sh SF16-tournaments_32+20+18+2x160_Copies-merged.pgn

/opt/chess/bayeselo2Elo.awk -v anchor_player="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -v anchor_Elo=1785 \
 'SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.bayeselo_ratings.txt' > 'SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.bayeselo_ratings-Elo.txt'

ordo --white-auto --draw-auto --average=1785 --anchor="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -p SF16-tournaments_32+20+18+2x160_Copies-merged.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 

ordo -g SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.ordo-g.txt  --white-auto --draw-auto --average=1785 --anchor="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" -p SF16-tournaments_32+20+18+2x160_Copies-merged.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 

COMMENT

<<'COMMENT'
pgn-extract ${name_all}.pgn \
 -Tp"stockfish_16_acherm_handicapped" \
 -Tp"stockfish_16_acherm_handicapped2" \
 -Tp"Stockfish_Ver16_UCI_Elo=1785_tc=40/15min-Copy1" \
 -Tp"Stockfish_Ver16_UCI_Elo=1785_tc=40/15min-Copy2" \
 -n SF16-tournaments_UNselected.pgn \
 --output SF16-tournaments_selected.pgn 2>SF16-tournaments_selected.pgn.stderr 1>SF16-tournaments_selected.pgn.stdout

#cat << EOF > pgn_tags.txt
% filter forfeits
Termination "time forfeit"
EOF

pgn-extract -t pgn_tags.txt \
 SF16-tournaments_UNselected.pgn \
 -n SF16-tournaments_selected.pgn \
 --output SF16-tournaments_time_forfeit.pgn 2>SF16-tournaments_time_forfeit.pgn.stderr 1>SF16-tournaments_time_forfeit.pgn.stdout

COMMENT


