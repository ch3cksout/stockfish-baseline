#!/bin/bash

# hunting for weird segfault...
# crashes w/ option.Hash=4000 

# run Stockfish Elo baseline testing, for Skill Level 4	~=	1785 Elo
#<https://github.com/official-stockfish/Stockfish/issues/3635#issuecomment-1159552166>
#https://disservin.github.io/stockfish-docs/pages-fishtest/Build-cutechess-with-Qt5-static.html
# engine binary downloaded from <https://ipmanchess.yolasite.com/compiles.php>

# match against Stockfish engine, as setup per "Stochastic parrot experiments" code
# <https://github.com/clevcode/skynet-dev/blob/main/checkmate.py>
# ch3cksout@skiff.com: localhost, running stockfish_15.1 installed from standard debian distribution

# ? round-robin or gauntlet
cutechess-cli -repeat -rounds 1 -games 2 -tournament round-robin \
                -event "Stockfish Elo baseline testing: various time controls" -site "ch3cksout@skiff.com: localhost" \
                -resign movecount=3 score=600 -draw movenumber=34 movecount=8 score=20 \
                -concurrency 1 -openings file=/var/chess/UHO_XXL_+0.90_+1.19.epd format=epd order=random plies=16 \
                -engine tc=40/10.0+0.6 name=Threads1_-Copy1 cmd=/usr/games/stockfish option.UCI_LimitStrength=true option.UCI_Elo=1700 \
                	option.Threads=10 \
                	option.Hash=2000 \
                	option.EvalFile=/var/chess/nn-ad9b42354671.nnue option."Use NNUE=true" \
                -engine tc=40/10.0+0.6 name=Threads1_-Copy2 cmd=/usr/games/stockfish option.UCI_LimitStrength=true option.UCI_Elo=1700 \
                	option.Threads=10 \
                	option.Hash=2000 \
                	option.EvalFile=/var/chess/nn-ad9b42354671.nnue option."Use NNUE=true" \
                -ratinginterval 1 -each proto=uci -pgnout $0_result.pgn

# NOTE stockfish/16-dev version does not need ' option."Use NNUE=true" ', unlike e.g. ver.14


