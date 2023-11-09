#!/bin/bash
# calculate Elo for 1 input PGN

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "You must enter exactly one argument"
    exit 1
fi

# If exactly one argument was passed, print it
echo "PGN file: $1"

ordo --white-auto --draw-auto -p $1 -o $1.ordo.txt -g $1.ordo-g.txt --average=1785 --anchor="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms"

/opt/chess/bayeselo.sh $1

/opt/chess/bayeselo2Elo.awk -v anchor_player="Threads10_stockfish_15.1_Elo1785_40_60,000+600ms -v anchor_Elo=1785 \
 $1.bayeselo_ratings.txt > $1.bayeselo_ratings-Elo.txt

