echo "#cp copy2repo.sh /opt/chess/repos/stockfish-baseline/acherm_SF16/Elo-calc/">copy2repo.sh

ls -t1 . /opt/chess/repos/stockfish-baseline/acherm_SF16/Elo-calc/ >>copy2repo.sh
sed -e's/^/cp /' copy2repo.sh -i
sed -e's%$% /opt/chess/repos/stockfish-baseline/acherm_SF16/Elo-calc/%' copy2repo.sh  -i

