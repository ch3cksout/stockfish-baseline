#!/bin/bash
#test

cat - |\
 /var/chess/engine_eval_pgn-stdin.py --Engine /var/chess-engines/stockfish_16 -o$0_stockfish_16-eval_White.pgn 2>>$0.stderr&

