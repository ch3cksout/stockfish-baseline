 This subdirectory has working files for Elo calculations on the game results presented by 
Mathieu Acher, in <https://github.com/acherm/gptchess/blob/main/games.tar.gz>.
In a preprocessing step, I made a combined PGN file of all games, <ALL-games_Elo-labeled.pgn>.
As an important prerequisite for evaluation, the player tags for Stockfish bots of different nominal strength were made distinct, by appending their stated Elo to the name. 
This file was then split into appropriate subsets for processing, as needed.

 In order to determine consistent ratings, two different methods are used.
The program 'ordo' can yield absolute Elo estimates, given one or multiple anchor values
 (see <https://github.com/michiguel/Ordo> for the code, as well as for documentation).

 In the current iteration of calculations,
  the [nominal strength of Stockfish clients](https://github.com/ch3cksout/stockfish-baseline/blob/master/acherm_SF16/Elo-calc/Elo-anchors.txt)
  are used for anchoring. They are taken from the source PGNs (and were specified by <https://github.com/acherm/gptchess/blob/main/gptchess/gpt-experiments.py>).

In this repo, results from 'ordo' runs are saved in filenames following the pattern <PGN-basename.out>.

The program 'bayeselo' uses a different algorithm. In its typical application, it yields relative Elo differences rather than absolute estimates; using this way it does not need anchor values, although they too can be provided as offsets
 (see <[https://github.com/michiguel/Ordo](https://www.remi-coulom.fr/Bayesian-Elo/)> for the code; the interactive help echoed by the program is captured in files <bayeselo.help> and <bayeselo_elo.help>, also uploaded here). This program is routinely used for evaluating the official ["Computer Chess Rating Lists"](http://ccrl.chessdom.com/ccrl/404/about.html), CCRL.

In this repo, results from 'bayeselo' runs are saved in filenames following the pattern
 <PGN-fullname.bayeselo_ratings.txt>.
