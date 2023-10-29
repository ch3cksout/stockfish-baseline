#/var/chess/engine_eval_pgn-stdin.py -i /opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956.pgn --Engine /var/chess-engines/asmFishL_2017-05-22_bmi2 -o/opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956_asmFishL-eval_White.pgn 2>$0.stderr&

/var/chess/engine_eval_pgn-stdin.py -i /opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956.pgn --Engine /var/chess-engines/komodo-9.02-linux -o/opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956_komodo9-eval_White.pgn 2>>$0.stderr&

/var/chess/engine_eval_pgn-stdin.py -i /opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956.pgn --Engine /var/chess-engines/stockfish_14.1 -o/opt/chess/repos/stockfish-baseline/games/Byrne_Fischer_1956_stockfish_14.1-eval_White.pgn 2>>$0.stderr&



