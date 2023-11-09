#!/bin/bash
# run Stockfish Elo baseline testing, for Skill Level 4	~=	1785 Elo
#<https://github.com/official-stockfish/Stockfish/issues/3635#issuecomment-1159552166>
#https://disservin.github.io/stockfish-docs/pages-fishtest/Build-cutechess-with-Qt5-static.html

# match against Stockfish engine, as setup per Mathieu Acher's gptchess code
# <https://github.com/acherm/gptchess>
# ch3cksout@skiff.com: localhost, running Stockfish ver.16: stockfish-ubuntu-x86-64-avx2 

# cross-validating with runs per Adam Karvonen's chess_gpt_eval code
echo "run: $0, (5*4/2)x16x2 games, cross-validating runs"

# scaling times for real rated strength
# Stockfish internal ELo ratings are described at <https://github.com/vondele/Stockfish/commit/a08b8d4e9711c2>
# Elo rating has been calibrated at a time control of 60s+0.6sec and anchored to CCRL 40/4min.
# In turn, CCRL 40/4min was a fast time control setup ("Blitz", which currently applies even shorter times).
# Full playing strength is not reached until longer times are used, at least 40/15min.
#<http://computerchess.org.uk/ccrl/4040/about.html>
# Furthermore, the stated CCRL times are scaled to the testers' hardware speed,
#	relative to Stockfish Ver.10(AVX2) standard bench time of 2054ms (reference on i7-4770k 3.5GHz)

#<https://github.com/adamkarvonen/chess_gpt_eval/issues/5>
# 2023 M1 Mac benchmark 'stockfish bench 1024 16 26 default depth ':
#Total time (ms) : 127745
#Nodes searched  : 867724059
#Nodes/second    : 6792626
#% sysctl -n hw.logicalcpu
#10
# NOTE the above bench was run with wrong thread count, 16 specified instead of 10!
#	=
nps_M1Mac10CPU=6792626

#ch3cksout:localhost Intel(R)_Core(TM)_i7-9750H_CPU_@_2.60GHz
#"median Nodes/second from 10 benchmark runs", 10039582, "1-core!?"
#"TC-code(sec)","rescaled_TC-code(sec)"
#"240","174.27458617332035053440"
#"60+0.6","43.56864654333008763360+.43568646543330087633"
#"120+1","87.13729308666017526720+.72614410905550146056"
CCRL_localhost=0.72614410905550146056
#strTC40_15="40/$(echo 15*60*$CCRL_localhost|bc -l)" # calculate scaled time, for comparative CCRL medium time control 

# make strTC40_15 integer (to avoid possible problem with feeding a float to cutechess)
# note that $Rescaled_100ms remains a float, necessarily
strTC40_15=$(echo 15*60*$CCRL_localhost|bc -l)
strTC40_15=$(echo "scale=0; $strTC40_15/1"|bc -l)
strTC40_15="40/$strTC40_15"
echo strTC40_15="$strTC40_15"

#"loop-bench-10core_HEREDOC.sh_Loop_count=10_nCPU=10.bench.stderr","median Nodes/second from 10 benchmark runs",  9887948, "10-core!" 
nps_localhost10CPU=9887948
# add leading zero to 'bc' output:
Rescaled_100ms=$(echo "scale=6; 0.1 * ${nps_M1Mac10CPU} / ${nps_localhost10CPU}" | bc -l | awk '{printf "%.6f\n", $0}')
echo 0.1sec rescaled by nps_M1Mac10CPU/nps_localhost10CPU = ${Rescaled_100ms}

# ? round-robin or gauntlet
#BEWARE naming inconsistencies
# (kept for cross-ferencing between runs under ../acherm_SF16 & ../adamkarvonen_SF16)
#name="Stockfish_Ver16_Skill=4_st=0.100sec": localhost/CCRL scaled time, combined w/'timemargin=10'
#	(as opposed to 'timemargin=50' for runs under ../adamkarvonen_SF16)
#name="stockfish_16-SL4_acherm_handicapped_st=20ms": unscaled time, substring 'Ver' dropped, 'st=0.020', combined w/'timemargin=10'
#	(as opposed no 'timemargin', 'tc=1/0.020+0.020' for previous runs under ../acherm_SF16)
#		NOTE 'tc=1/0.020+0.020' does not do as intended, due to mis-specification it is rather the same as 'tc=1/0.020'!
#name="stockfish_16-SL4_acherm_handicapped_st=100ms": unscaled time, substring 'Ver' dropped, 'st=0.100', combined w/'timemargin=10'
#	for (approximate) comparison b/w acherm_SF16 & ../adamkarvonen_SF16, 20 & 100 ms resp.
cutechess-cli -repeat -rounds 16 -games 2 -tournament round-robin \
                -event "Stockfish Elo baseline testing: various time controls" -site "ch3cksout@skiff.com: localhost" \
                -resign movecount=3 score=600 -draw movenumber=34 movecount=8 score=20 \
                -concurrency 4 -openings file=/var/chess/UHO_XXL_+0.90_+1.19.epd format=epd order=random plies=16 \
                -engine tc="$strTC40_15" name="Stockfish_Ver16_UCI_Elo=1900_tc=40/15min" cmd=/opt/stockfish/16/avx2/stockfish-ubuntu-x86-64-avx2 option.UCI_LimitStrength=true option.UCI_Elo=1900 \
                	option.Threads=1 \
                	option.Hash=256 \
                	option.EvalFile=/var/chess/nn-5af11540bbfe.nnue option."Use NNUE=true" \
                -engine st="$Rescaled_100ms" name="Stockfish_Ver16_Skill=4_st=0.100sec" cmd=/opt/stockfish/16/avx2/stockfish-ubuntu-x86-64-avx2 option."Skill Level=4" \
                	option.Threads=1 \
                	option.Hash=16 \
                	option.EvalFile=/var/chess/nn-5af11540bbfe.nnue option."Use NNUE=true" \
                -engine st=0.020 name="stockfish_16-SL4_acherm_handicapped_st=20ms" cmd=/opt/stockfish/16/avx2/stockfish-ubuntu-x86-64-avx2 option."Skill Level=4" \
                	option.Threads=1 \
                	option.Hash=16 \
                	option.EvalFile=/var/chess/nn-5af11540bbfe.nnue option."Use NNUE=true" \
                -engine st=0.100 name="stockfish_16-SL4_acherm_handicapped_st=100ms" cmd=/opt/stockfish/16/avx2/stockfish-ubuntu-x86-64-avx2 option."Skill Level=4" \
                	option.Threads=1 \
                	option.Hash=16 \
                	option.EvalFile=/var/chess/nn-5af11540bbfe.nnue option."Use NNUE=true" \
                -engine tc="$strTC40_15" name="Stockfish_Ver16_UCI_Elo=1785_tc=40/15min" cmd=/opt/stockfish/16/avx2/stockfish-ubuntu-x86-64-avx2 option.UCI_LimitStrength=true option.UCI_Elo=1785 \
                	option.Threads=1 \
                	option.Hash=256 \
                	option.EvalFile=/var/chess/nn-5af11540bbfe.nnue option."Use NNUE=true" \
                -ratinginterval 1 -each timemargin=10 proto=uci -pgnout $0_result.pgn >$0.stdout 2>$0.stderr
#< Warning: stockfish_16-SL4_acherm_handicapped doesn't have option Minimum Thinking Time

# NOTE stockfish/16-dev version does not need ' option."Use NNUE=true" ', unlike e.g. ver.14

