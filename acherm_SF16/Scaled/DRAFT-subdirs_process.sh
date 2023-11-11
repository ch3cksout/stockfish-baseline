#testing
#+	./acherm_SF16_Run1B/
<<'COMMENT'
BEWARE the script below had destroyed the original PGN results,
	with the faulty redirect  $file >$file
for file in $(ls -ld ./*/*pgn) $(ls -ld ./acherm_SF16_Run1B/*pgn); do
#wrong spec ./acherm_SF16_Run1B/*pgn
#	should be ./acherm_SF16_Run1B/*/*pgn

    if [ -f "$file" ]; then
#BEWARE        /opt/chess/bayeselo.sh $file >$file
#        ordo --white-auto --draw-auto -p $file -o $file.ordo.txt -g $file..ordo-g.txt
    	echo "file='$file'"
    	head -1 "$file"
    fi
done

for dir in $(ls -ld ./acherm_SF16_Run*/) $(ls -ld ./acherm_SF16_Run1B/*/); do
    if [ -d "$dir" ]; then
	for file in $(echo $dir/*pgn); do
	    #echo 'in': "$(echo $dir/*pgn)" "file='$file'"
	    if [ -f "$file" ]; then
	    	#echo "file='$file'"
	    	basename $file
	    	head -1 "$file"
	    fi
	done
    fi
done

COMMENT


