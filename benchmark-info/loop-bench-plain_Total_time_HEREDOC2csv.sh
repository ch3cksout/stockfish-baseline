#!/bin/bash
# looping for tests to reproduce benchmark:
# https://ipmanchess.yolasite.com/amd--intel-chess-bench-stockfish.php
# the above list uses this console input: bench 1024 12 26 default depth nnue
#NOTE for asmFishW_2017-05-22, rather use this console input (had no nnue!): bench 12 128 26
# https://ipmanchess.yolasite.com/amd---intel-chess-bench.php

#HEREDOC version

#NOTE standard Stockfish uses stderr for summary output, asmFishW_2017-05-22 uses stdout only

# this particular setting replicates the "plain" bench call, recommended on the CCRL discussion forum:
#<https://kirill-kryukov.com/chess/discussion-board/viewtopic.php?t=1486&start=50#p117895>
#<https://web.archive.org/web/20230602174057/https://kirill-kryukov.com/chess/discussion-board/viewtopic.php?t=1486&start=50#p117895>

EXE="./stockfish_10_x64_bmi2"

if [ $# -eq 0 ]
  then
    echo "No arguments supplied - expected input is the number of loops!"
    echo TEST of script $0
    Threads=$(eval $EXE uci |sed -ne '/Threads/s/^option name Threads type spin default \([0-9][0-9]*\).*/\1/p')
    echo Threads=$Threads
    Hash=$(eval $EXE uci |sed -ne '/Hash/s/^option name Hash type spin default \([0-9][0-9]*\).*/\1/p')
    echo Hash=$Hash
    # >$0_Loop_count=$1_Threads=$Threads.bench.stderr
  else (
	#Threads="UNSPECIFIED"
	Threads=$(eval $EXE uci |sed -ne '/Threads/s/^option name Threads type spin default \([0-9][0-9]*\).*/\1/p')
	Hash=$(eval $EXE uci |sed -ne '/Hash/s/^option name Hash type spin default \([0-9][0-9]*\).*/\1/p')
	eval $EXE uci |grep 'id name' >$0_Loop_count=$1_Threads=${Threads}_Hash=${Hash}.bench.stderr
	echo Threads: $Threads >>$0_Loop_count=$1_Threads=${Threads}_Hash=${Hash}.bench.stderr
	echo Hash: $Hash >>$0_Loop_count=$1_Threads=${Threads}_Hash=${Hash}.bench.stderr
	echo "Loop count: $1" 
	echo '"EXE-file","Script","Loop-index","Total_time"' >${EXE}_Total_time.csv
	min=0
	max=0
	sum=0
	for ((i=1; i<=$1; i++))
	do
		echo "Loop index: $i" 
		#capture result in variable
		result=$(eval $EXE <<EOF  2>&1 >/dev/null
bench
quit
EOF
		)
		# 1>>$0_Loop_count=$1_Threads=$Threads.bench.stdout 2>>$0_Loop_count=$1_Threads=$Threads.bench.stderr
		Total_time=$(echo $result |sed -e's/.*Total time (ms) : *\([0-9][0-9]*\).*$/\1/')
		#echo Total_time=$Total_time
		echo \"$EXE\",\"$0\",$i,$Total_time >>${EXE}_Total_time.csv
		if [[ $i == 1 ]]
		then
			min=$Total_time
			max=$Total_time
		fi
		if [[ $Total_time -lt $min ]]
		then
			min=$Total_time
		fi
		if [[ $Total_time -gt $max ]]
		then
			max=$Total_time
		fi
		sum=$((sum + Total_time))
		#echo sum=$sum
    	done
	if [[ $1 -gt 2 ]]
	then
		sum=$((sum - min -max))
		nAVG=$1
		((nAVG--))
		((nAVG--))
	else
		nAVG=$1
	fi
	#echo Trimmed_AVG calc: sum=$sum nAVG=$nAVG 
	sum=$(echo "$sum / $nAVG" | bc -l)
	#echo Trimmed_AVG=$sum
	echo \"$EXE\",\"Trimmed_AVG\",$1,$sum >>${EXE}_Total_time.csv
	)
fi

