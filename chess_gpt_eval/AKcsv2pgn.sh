#!/bin/bash
gawk -f AKcsv2pgn.awk -v file_path=$(realpath --relative-to="$HOME/.local/gptchess/" "$@") "$@" 1> $0.stdout  2>$0.stderr

