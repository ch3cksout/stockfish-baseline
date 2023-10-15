#!/bin/bash
# run Stockfish Elo baseline testing, for Skill Level 4	~=	1785 Elo
#<https://github.com/official-stockfish/Stockfish/issues/3635#issuecomment-1159552166>
#https://disservin.github.io/stockfish-docs/pages-fishtest/Build-cutechess-with-Qt5-static.html
# engine binary downloaded from <https://ipmanchess.yolasite.com/compiles.php>

cutechess-cli -repeat -rounds 16 -games 2 -tournament gauntlet \
                -event "Stockfish Elo baseline testing" -site "ch3cksout@skiff.com: localhost" \
                -resign movecount=3 score=600 -draw movenumber=34 movecount=8 score=20 \
                -concurrency 1 -openings file=/var/chess/UHO_XXL_+0.90_+1.19.epd format=epd order=random plies=16 \
                -engine name=Elo1785 cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine name=SkillLevel7 cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option."Skill Level=7" \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -ratinginterval 1 -each tc=40/2400.0 proto=uci option.Threads=10 -pgnout $0_result.pgn

