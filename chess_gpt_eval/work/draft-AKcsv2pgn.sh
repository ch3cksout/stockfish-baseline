#!/bin/bash
gawk -f AKcsv2pgn.awk -v file_path=$(realpath --relative-to="$HOME/.local/gptchess/" "$1") "$1" 1> $(basename $1 .csv).pgn  2>$0.stderr

