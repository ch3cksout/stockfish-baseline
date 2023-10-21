#!/bin/bash

# calculate Elo ratings with ordo
#multiple anchors: file contains rows of: "AnchorName",AnchorRating

#ordo --multi-anchors=Elo-anchors.txt --pgn=./ALL-games_Elo-labeled.pgn --output=./ALL-games_Elo-labeled.out
#* Run switch -g to find what groups need more games *
#ordo --multi-anchors=Elo-anchors.txt --pgn=./ALL-games_Elo-labeled.pgn --output=./ALL-games_Elo-labeled.out --groups=ALL-games_Elo-labeled.groups

# pre-process
#<https://www.cs.kent.ac.uk/people/staff/djb/pgn-extract/help.html>
#Tag criteria on the command line (-T)
#-TpPlayer - Extract games where Player has either colour.

#pgn-extract -Tptext-davinci-003 --output text-davinci-003.pgn ALL-games_Elo-labeled.pgn
#pgn-extract --noduplicates --checkfile text-davinci-003.pgn --output NON_text-davinci-003.pgn ALL-games_Elo-labeled.pgn

ordo --draw-auto --white=35 --multi-anchors=Elo-anchors.txt --pgn=./NON_text-davinci-003.pgn --output=./NON_text-davinci-003.out

# --white=35 
#<https://en.wikipedia.org/wiki/First-move_advantage_in_chess>

