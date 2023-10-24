#!/bin/bash
# looping for tests to reproduce time control scaling based on Stockfish benchmark:
# this particular setting replicates the "plain" bench call, recommended on the CCRL discussion forum:
#<https://kirill-kryukov.com/chess/discussion-board/viewtopic.php?t=1486&start=50#p117895>
#<https://web.archive.org/web/20230602174057/https://kirill-kryukov.com/chess/discussion-board/viewtopic.php?t=1486&start=50#p117895>

reftime_ms=2054

#HEREDOC version, with CSV output of Total time statistics, and separate file for scaled time control 

EXE="./stockfish_10_x64_bmi2"

if [ $# -eq 0 ]
  then
	echo "No arguments supplied - expected input is the number of loops!"
	echo TEST of script $0
#	echo TCout=$TCout
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
	#'$sum' now has the Trimmed AVG calculated
	#echo Trimmed_AVG=$sum
	echo \"$EXE\",\"Trimmed_AVG\",$1,$sum >>${EXE}_Total_time.csv
	
	#reftime_ms=2054
	TCout=time_controls_$(lscpu | sed -ne'/Model name:/s/ /_/g;s/Model_name:_*//p').csv
	echo '"TC-code(sec)","rescaled_TC-code(sec)"' >$TCout
	echo \"240\",\"$(echo " $sum / $reftime_ms * 240" | bc -l)\" >>$TCout
	echo \"60+0.6\",\"$(echo " $sum / $reftime_ms * 60" | bc -l)+$(echo " $sum / $reftime_ms * 0.6" | bc -l)\" >>$TCout
	echo \"120+1\",\"$(echo " $sum / $reftime_ms * 120" | bc -l)+$(echo " $sum / $reftime_ms * 1" | bc -l)\" >>$TCout

	)
fi

