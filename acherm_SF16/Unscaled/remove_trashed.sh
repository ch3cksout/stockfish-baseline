#!/bin/bash
#	remove files overwritten by "bayeselo" redirect

<<'COMMENT'
BEWARE the old 'subdirs_process.sh' script had destroyed the original PGN results,
	with the faulty redirect  $file >$file

# this code would make a standalone cleanup script
# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 directory string"
    exit 1
fi

# Assign the arguments to variables for better readability
directory=$1
#...
    # Read the first line of the file
    first_line=$(head -n 1 "$file")

    # If the first line matches the string, remove the file
    if [ "$first_line" == "$string" ]; then
        rm "$file"
    fi
COMMENT

string="version 0057, Copyright (C) 1997-2010 Remi Coulom."

# Iterate over all files in the directory
for file in $(ls -1 ./acherm_SF16_Run*/*pgn) $(ls -1 ./acherm_SF16_Run1B/*/*pgn); do
    if [ -f "$file" ]; then
	    # echo "file='$file'"
	    # Read the first line of the file
	    first_line=$(head -n 1 "$file")

	    # If the first line matches the string, remove the file
	    if [ "$first_line" == "$string" ]; then
		echo TO REMOVE: "$file"
		rm "$file"
	    fi
    fi

done

