#!/usr/bin/env python3
# by ch3cksout@skiff.com
import openai
from dotenv import load_dotenv
import os

# run this before calling: OPENAI_API_KEY=$(cat ~/.local/gptchess/chess_gpt_eval/gpt_inputs/api_key.txt);export OPENAI_API_KEY
print(openai.api_key)

#+	@ch3cksout
#os.setenv("OPENAI_KEY", "~/.local/gptchess/chess_gpt_eval/gpt_inputs/api_key.txt")
load_dotenv()
print(os.getenv('OPENAI_KEY'))

openai.api_key = os.getenv('OPENAI_KEY')
print(openai.api_key)


