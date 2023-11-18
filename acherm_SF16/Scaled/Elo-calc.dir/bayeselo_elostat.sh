#!/bin/bash
# run bayeselo, for ratings calculation with PGN gve as '$1'
# shell script input to pass HERE document into the internal consol interfaces
echo '$1:' input PGN
echo '$2:' anchoring Elo
echo '$3:' anchoring player

# offset [elo [pl]] get[set] Elo offset, or player (pl) elo

/opt/chess/bayeselo <<EOF
readpgn $1
elo
offset $2 $3
elostat
ratings >$1.$(basename $0)_ratings.txt
x
x
EOF

