# SF16-match2_cutechess.sh_result.pgn SF16-match2_INT_cutechess.sh_result.pgn SF16-match2B_INT_cutechess.sh_result.pgn
#SF16-match2B_INT_cutechess.sh_result.pgn
#SF16-match2C_INT_cutechess.sh_result.pgn

<<'COMMENT'
grep ' of ' SF16-tournament_cutechess.sh.stdout|head -1
grep ' of ' SF16-match2_cutechess.sh.stdout|head -1
grep ' of ' SF16-match2_INT_cutechess.sh.stdout|head -1
grep ' of ' SF16-match2B_INT_cutechess.sh.stdout|head -1
grep ' of ' SF16-match2C_INT_cutechess.sh.stdout|head -1

COMMENT

#= 240+3x16+32
pgn-extract \
SF16-tournament_cutechess.sh_result.pgn \
SF16-match2_cutechess.sh_result.pgn \
SF16-match2_INT_cutechess.sh_result.pgn \
SF16-match2B_INT_cutechess.sh_result.pgn \
SF16-match2C_INT_cutechess.sh_result.pgn \
 --output SF16-tournaments_240+3x16+32.pgn

ordo --white-auto --draw-auto --average=1900 --anchor="Stockfish_Ver16_UCI_Elo=1900_tc=40/15min" -p SF16-tournaments_240+3x16+32.pgn -o SF16-tournaments_240+3x16+32.ordo.txt

/opt/chess/bayeselo.sh SF16-tournaments_240+3x16+32.pgn

/opt/chess/bayeselo2Elo.awk -v anchor_player="Stockfish_Ver16_UCI_Elo=1900_tc=40/15min" -v anchor_Elo=1900 \
 'SF16-tournaments_240+3x16+32.pgn.bayeselo_ratings.txt' > 'SF16-tournaments_240+3x16+32.pgn.bayeselo_ratings-Elo.txt'


