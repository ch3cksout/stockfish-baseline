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

stockfish.reset_engine_parameters()
print("\n After 'stockfish.reset_engine_parameters()':")
print("\n stockfish.get_parameters():")
print(stockfish.get_parameters())

stockfish.update_engine_parameters({"Minimum Thinking Time": 100}) # Gets stockfish to use 100 ms
stockfish.update_engine_parameters({"Skill Level": 9}) # Gets stockfish to use Skill Level 9
print("\n After '\"Skill Level\": 9':")
print("\n stockfish.get_parameters():")
print(stockfish.get_parameters())


