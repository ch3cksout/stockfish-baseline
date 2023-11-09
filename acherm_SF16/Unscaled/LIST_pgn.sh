#!/bin/bash
#	just list

<<'COMMENT'
BEWARE the old 'subdirs_process.sh' script had destroyed the original PGN results,
	with the faulty redirect  $file >$file

COMMENT

# Iterate over all files in the directory
for file in $(ls -1 ./acherm_SF16_Run*/*pgn  ./acherm_SF16_Run1B/*/*pgn); do
    if [ -f "$file" ]; then
	    echo "file='$file'"
    fi

done

