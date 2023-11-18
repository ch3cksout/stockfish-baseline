#!/bin/bash
$HOME/.local/gptchess/bin/python $HOME/.local/gptchess/chess_gpt_eval/2repo/Stockfish_selftest-Elo1800_main.py 2>$0.stderr |tee $0.stdout 


