#!/bin/bash
# run bayeselo, for ratings calculation with PGN gve as '$1'
# shell script input to bypass the programs internal consol interfaces

/opt/chess/bayeselo <<EOF
readpgn $1
elo
mm
ratings >$1.work-bayeselo_ratings.txt
x
prediction rounds 2
?
results
?
addplayer "Stockfish_Ver16_UCI_Elo=1785_tc=40/15min"
addplayer "Stockfish_Ver16_Skill=4_st=0.100sec"
simulate
x
EOF

