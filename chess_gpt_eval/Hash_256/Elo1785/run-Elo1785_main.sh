#!/bin/bash
# run AFTER 'source $HOME/.local/gptchess/bin/activate'

#!/bin/bash

directories=("gpt_outputs" "logs")

for directory in "${directories[@]}"; do
    # Check if the directory exists
    if [ -d "$directory" ]; then
        echo "Directory '$directory' already exists"
    else
        # If the directory doesn't exist, create it
        mkdir -p "$directory"
        echo "Directory '$directory' created"
    fi
done

$HOME/.local/gptchess/bin/python Elo1785_main.py 2>$0.stderr |tee $0.stdout 

