#!/bin/bash
# run bayeselo, for ratings calculation with PGN gve as '$1'
# shell script input to bypass the programs internal consol interfaces

/opt/chess/bayeselo <<EOF
readpgn $1
elo
mm
ratings >$1.bayeselo_ratings.txt
EOF

