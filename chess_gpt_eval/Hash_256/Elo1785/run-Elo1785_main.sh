#!/bin/bash
# run AFTER 'source $HOME/.local/gptchess/bin/activate'
$HOME/.local/gptchess/bin/python Elo1785_main.py 2>$0.stderr |tee $0.stdout 


