#!/bin/bash
# calculate Elo for 1 input PGN

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "You must enter exactly one argument"
    exit 1
fi

# If exactly one argument was passed, print it
echo "PGN file: $1"

# anchor with ../Run5A/acherm_SF16-match_cutechess.sh_result.pgn.ordo.txt
ordo --white-auto --draw-auto -p $1 -o $1.ordo.txt -g $1.ordo-g.txt --average=1458.4 --anchor="Stockfish_Ver16_Skill=5_st=0.100sec"

/opt/chess/bayeselo.sh $1

/opt/chess/bayeselo2Elo.awk -v anchor_player="Stockfish_Ver16_Skill=5_st=0.100sec" -v anchor_Elo=1458.4 \
 $1.bayeselo_ratings.txt > $1.bayeselo_ratings-Elo.txt


