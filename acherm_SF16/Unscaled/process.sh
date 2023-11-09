<<'COMMENT'
acherm_SF16_Run1B/Test3/match2_test1-acherm_SF16-match_cutechess.sh_result.pgn
acherm_SF16_Run1C/match2_test1-acherm_SF16-match_cutechess.sh_result.pgn
acherm_SF16_Run1/test1-acherm_SF16-match_cutechess.sh_result.pgn
acherm_SF16_Run2A/acherm_SF16-match_cutechess.sh_result.pgn
acherm_SF16_Run2B/acherm_SF16-match_cutechess.sh_result.pgn
acherm_SF16_Run3/acherm_SF16-match_cutechess.sh_result.pgn

grep Event acherm_SF16_Run1B/Test3/match2_test1-acherm_SF16-match_cutechess.sh_result.pgn |wc -l
grep Event acherm_SF16_Run1C/match2_test1-acherm_SF16-match_cutechess.sh_result.pgn |wc -l
grep Event acherm_SF16_Run1/test1-acherm_SF16-match_cutechess.sh_result.pgn |wc -l
grep Event acherm_SF16_Run2A/acherm_SF16-match_cutechess.sh_result.pgn |wc -l
grep Event acherm_SF16_Run2B/acherm_SF16-match_cutechess.sh_result.pgn |wc -l
grep Event acherm_SF16_Run3/acherm_SF16-match_cutechess.sh_result.pgn |wc -l
#=
11
32
20
18
160
160
COMMENT

<<'COMMENT'
#= 32+20+18+2x160
pgn-extract \
acherm_SF16_Run1C/match2_test1-acherm_SF16-match_cutechess.sh_result.pgn  \
acherm_SF16_Run1/test1-acherm_SF16-match_cutechess.sh_result.pgn  \
acherm_SF16_Run2A/acherm_SF16-match_cutechess.sh_result.pgn  \
acherm_SF16_Run2B/acherm_SF16-match_cutechess.sh_result.pgn  \
acherm_SF16_Run3/acherm_SF16-match_cutechess.sh_result.pgn  \
 --output SF16-tournaments_32+20+18+2x160.pgn

/opt/chess/bayeselo.sh SF16-tournaments_32+20+18+2x160.pgn

/opt/chess/bayeselo2Elo.awk -v anchor_player="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms" -v anchor_Elo=1785 \
 'SF16-tournaments_32+20+18+2x160.pgn.bayeselo_ratings.txt' > 'SF16-tournaments_32+20+18+2x160.pgn.bayeselo_ratings-Elo.txt'

ordo --white-auto --draw-auto --average=1785 --anchor="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms" -p SF16-tournaments_32+20+18+2x160.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 
ordo  -p SF16-tournaments_32+20+18+2x160.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt -g ordo_g_white-auto

sed -e "s/-Copy[1-9]//" SF16-tournaments_32+20+18+2x160.pgn > SF16-tournaments_32+20+18+2x160_Copies-merged.pgn

/opt/chess/bayeselo.sh SF16-tournaments_32+20+18+2x160_Copies-merged.pgn

/opt/chess/bayeselo2Elo.awk -v anchor_player="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms" -v anchor_Elo=1785 \
 'SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.bayeselo_ratings.txt' > 'SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.bayeselo_ratings-Elo.txt'

ordo --white-auto --draw-auto --average=1785 --anchor="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms" -p SF16-tournaments_32+20+18+2x160_Copies-merged.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 

ordo -g SF16-tournaments_32+20+18+2x160_Copies-merged.pgn.ordo-g.txt  --white-auto --draw-auto --average=1785 --anchor="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms" -p SF16-tournaments_32+20+18+2x160_Copies-merged.pgn -o SF16-tournaments_32+20+18+2x160.ordo.txt 

COMMENT


