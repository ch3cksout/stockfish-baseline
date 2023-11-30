#!/usr/bin/env python3
# by ch3cksout@skiff.com
from stockfish import Stockfish

import chess
import os

import datetime
DT = datetime.datetime.now()

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

elo_rating = 1800
mtt = 2000
stockfish.set_elo_rating(1800)

#+        @ch3cksout
stockfish.update_engine_parameters({"Minimum Thinking Time": mtt}) 
print("\n After 'stockfish.update_engine_parameters()':")
# Gets stockfish to use 'mtt' ms (instead of the default 20)!
print(stockfish.get_parameters())

i = 1
mtt = 2000
elo_rating = 1800
print(f"Starting {i}. game")
pgn = f"""[Event "Testing checkmate_Elo1800.py vs. Stockfish"]
[Site "localhost"]
[Date "{DT}"]
[Round "{i}"]
[White "gpt-3.5-turbo-instruct via Stochastic parrot, <https://github.com/clevcode/skynet-dev>"]
[Black "Stockfish Elo:{elo_rating}, {mtt} ms"]
[Result "TBD"]
[WhiteElo "{elo_rating}"]
[BlackElo "TBD"]
[TimeControl "TBD"]
[Variant "Standard"]

1."""

print("pgn: \n" + pgn)

