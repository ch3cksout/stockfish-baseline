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

#ordo --draw-auto --white=35 --multi-anchors=Elo-anchors.txt --pgn=./NON_text-davinci-003.pgn --output=./NON_text-davinci-003.out

#pgn-extract -TpRANDOM --output RANDOM.pgn NON_text-davinci-003.pgn
#pgn-extract --noduplicates --checkfile RANDOM.pgn --output NON_RANDOM.pgn NON_text-davinci-003.pgn

# keep only gpt-3.5-turbo-instruct in RANDOM.pgn!
set DUMMY="
cp Elo-anchors.txt RANDOM_Elo-anchors.txt
echo '"RANDOM chess engine",760.6' >> RANDOM_Elo-anchors.txt
sed -i -e'/Stockfish_Elo1597/d' RANDOM_Elo-anchors.txt 
sed -i -e'/Stockfish_Elo1694/d' RANDOM_Elo-anchors.txt 
sed -i -e'/Stockfish_Elo1785/d' RANDOM_Elo-anchors.txt 
sed -i -e'/Stockfish_Elo1871/d' RANDOM_Elo-anchors.txt 
sed -i -e'/Stockfish_Elo1954/d' RANDOM_Elo-anchors.txt 
sed -i -e'/Stockfish_Elo2035/d' RANDOM_Elo-anchors.txt 
"

#pgn-extract -Tp"gpt-3.5-turbo-instruct" --output gpt-3.5-turbo-instruct.pgn NON_text-davinci-003.pgn
#pgn-extract -Tp"gpt-3.5-turbo" --noduplicates --checkfile gpt-3.5-turbo-instruct.pgn --output gpt-3.5-turbo.pgn NON_text-davinci-003.pgn

#pgn-extract -Tp"gpt-3.5-turbo-instruct" --output gpt-3.5-turbo-instruct+RANDOM.pgn RANDOM.pgn
#pgn-extract -Tp"gpt-3.5-turbo" --noduplicates --checkfile gpt-3.5-turbo-instruct+RANDOM.pgn --output gpt-3.5-turbo+RANDOM.pgn RANDOM.pgn

#ordo --groups=gpt-3.5-turbo-instruct+RANDOM.groups --draw-auto --white=35  --anchor="RANDOM chess engine" --average=760.6 --pgn=gpt-3.5-turbo-instruct+RANDOM.pgn --output=gpt-3.5-turbo-instruct+RANDOM.out
#ordo --draw-auto --white=35  --anchor="RANDOM chess engine" --average=760.6 --pgn=gpt-3.5-turbo-instruct+RANDOM.pgn --output=gpt-3.5-turbo-instruct+RANDOM.out

#pgn-extract --noduplicates --checkfile RANDOM.pgn --output NON_RANDOM-gpt-3.5-turbo.pgn gpt-3.5-turbo.pgn

#pgn-extract --noduplicates --checkfile gpt-3.5-turbo.pgn --output NON_RANDOM-gpt-3.5-turbo.pgn NON_RANDOM.pgn 

#ordo --groups=NON_RANDOM.groups --draw-auto --white=35 --multi-anchors=Elo-anchors.txt --pgn=NON_RANDOM.pgn --output=NON_RANDOM.out

#ordo --groups=NON_RANDOM-gpt-3.5-turbo.groups --draw-auto --white=35 --multi-anchors=Elo-anchors.txt --pgn=NON_RANDOM-gpt-3.5-turbo.pgn --output=NON_RANDOM-gpt-3.5-turbo.out

# --white=35 
#<https://en.wikipedia.org/wiki/First-move_advantage_in_chess>

