#!/bin/bash
# calculate Elo for 1 input PGN

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "You must enter exactly one argument"
    exit 1
fi

# If exactly one argument was passed, print it
echo "PGN file: $1"

ordo --white-auto --draw-auto -p $1 -o $1.ordo.txt -g $1.ordo-g.txt

/opt/chess/bayeselo.sh $1


