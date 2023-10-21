#!/bin/bash

# trying to track segfault

# run Stockfish Elo baseline testing, for Skill Level 4	~=	1785 Elo
#<https://github.com/official-stockfish/Stockfish/issues/3635#issuecomment-1159552166>
#https://disservin.github.io/stockfish-docs/pages-fishtest/Build-cutechess-with-Qt5-static.html
# engine binary downloaded from <https://ipmanchess.yolasite.com/compiles.php>

# match against Stockfish engine, as setup per Mathieu Acher's gptchess code
# <https://github.com/acherm/gptchess>
# ch3cksout@skiff.com: localhost, running Stockfish ver.16: stockfish-ubuntu-x86-64-avx2 

# ? round-robin or gauntlet
cutechess-cli -repeat -rounds 16 -games 2 -tournament round-robin \
                -event "Stockfish Elo baseline testing: trying to track segfault" -site "ch3cksout@skiff.com: localhost" \
                -resign movecount=3 score=600 -draw movenumber=34 movecount=8 score=20 \
                -concurrency 1 -openings file=/var/chess/UHO_XXL_+0.90_+1.19.epd format=epd order=random plies=16 \
                -engine tc=40/60.0+0.6 name=Threads10_stockfish_15.1_Elo1785_40_60,000+600ms-Copy1 cmd=/usr/games/stockfish option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.Threads=10 \
                	option.Hash=1600 \
                	option.EvalFile=/var/chess/nn-ad9b42354671.nnue option."Use NNUE=true" \
                -engine tc=40/60.0+0.6 name=Threads10_stockfish_15.1_Elo1785_40_60,000+600ms-Copy2 cmd=/usr/games/stockfish option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.Threads=10 \
                	option.Hash=1600 \
                	option.EvalFile=/var/chess/nn-ad9b42354671.nnue option."Use NNUE=true" \
                -ratinginterval 1 -each proto=uci -pgnout $0_result.pgn
#< Warning: stockfish_16-SL4_acherm_handicapped doesn't have option Minimum Thinking Time

# NOTE stockfish/16-dev version does not need ' option."Use NNUE=true" ', unlike e.g. ver.14

