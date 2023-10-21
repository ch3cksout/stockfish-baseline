 This subdirectory has the working files for Elo calculations on the game results presented by 
Mathieu Acher, in <https://github.com/acherm/gptchess/blob/main/games.tar.gz>.

 In order to determine consistent ratings, the program ordo is used
 (see <https://github.com/michiguel/Ordo> for the code, as well as for documentation).

 In the current iteration of calculations,
  the [nominal strength of Stockfish clients](https://github.com/ch3cksout/stockfish-baseline/blob/master/acherm_SF16/Elo-calc/Elo-anchors.txt)
  are used for anchoring. They are taken from the source PGNs (and were specified by <https://github.com/acherm/gptchess/blob/main/gptchess/gpt-experiments.py>).

 
