#!/bin/bash
pgn-extract -Tw"stockfish_15.1_skynet-dev_handicapped" SF_skynet-dev-match_cutechess.sh_result.pgn -oWhite-SF_skynet-dev-match_cutechess.pgn
pgn-extract -Tb"Threads1_stockfish_15.1_Elo1700_40_60,000+600ms" SF_skynet-dev-match_cutechess.sh_result.pgn -oBlack-SF_skynet-dev-match_cutechess.pgn

