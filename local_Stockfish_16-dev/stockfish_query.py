#!/usr/bin/env python3
# by ch3cksout@skiff.com
from stockfish import Stockfish

import chess
import os

stockfish = Stockfish()
stockfish.set_elo_rating(1700)
board = chess.Board()

#print("\033c" + stockfish.get_board_visual())

print("\n stockfish.get_stockfish_major_version():")
print(stockfish.get_stockfish_major_version())

print("\n stockfish.get_parameters():")
print(stockfish.get_parameters())


