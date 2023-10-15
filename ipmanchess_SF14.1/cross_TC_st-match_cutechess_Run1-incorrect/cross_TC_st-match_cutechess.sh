#!/bin/bash
# run Stockfish Elo baseline testing, for Skill Level 4	~=	1785 Elo
#<https://github.com/official-stockfish/Stockfish/issues/3635#issuecomment-1159552166>
#https://disservin.github.io/stockfish-docs/pages-fishtest/Build-cutechess-with-Qt5-static.html
# engine binary downloaded from <https://ipmanchess.yolasite.com/compiles.php>

# ? round-robin or gauntlet
cutechess-cli -repeat -rounds 4 -games 2 -tournament round-robin \
                -event "Stockfish Elo baseline testing: various time controls" -site "ch3cksout@skiff.com: localhost" \
                -resign movecount=3 score=600 -draw movenumber=34 movecount=8 score=20 \
                -concurrency 1 -openings file=/var/chess/UHO_XXL_+0.90_+1.19.epd format=epd order=random plies=16 \
                -engine tc=40/60.0+0.6 name=Elo1785_40_60,000+600ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine tc=40/240.0 name=Elo1785_40_240,000ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine tc=40/240.0 name=SkillLevel4_40_240,000ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option."Skill Level=4" \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine tc=/240.0 name=Elo1685_40_240,000ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1685 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine tc=40/240.0 name=Elo1885_40_240,000ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1885 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine st=0.020 name=Elo1785_20ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -engine st=0.100 name=Elo1785_100ms cmd=/var/chess/ipmanchess/stockfish_21102807_x64_bmi2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.EvalFile=/var/chess/ipmanchess/nn-13406b1dcbe0.nnue option."Use NNUE=true" \
                -ratinginterval 1 -each proto=uci option.Threads=10 -pgnout $0_result.pgn

