# modify title content...
import openai
import chess
import chess.engine
import os
import csv
import random
import time

import gpt_query

from typing import Optional, Tuple
from dataclasses import dataclass


@dataclass
class LegalMoveResponse:
    move_san: Optional[str] = None
    move_uci: Optional[chess.Move] = None
    attempts: int = 0
    is_resignation: bool = False
    is_illegal_move: bool = False


# Define base Player class
class Player:
    def get_move(self, board: chess.Board, game_state: str, temperature: float) -> str:
        raise NotImplementedError

    def get_config(self) -> dict:
        raise NotImplementedError


class GPTPlayer(Player):
    def __init__(self, model: str):
        self.model = model

    def get_move(
        self, board: chess.Board, game_state: str, temperature: float
    ) -> Optional[str]:
        # pause for throttling rate to keep below openai limit (current Limit: 3 requests per min): time.sleep(31.3) 
        response = get_gpt_response(game_state, self.model, temperature)
        return get_move_from_gpt_response(response)

    def get_config(self) -> dict:
        return {"model": self.model}


class StockfishUCIElo(Player):
    def __init__(self, skill_level: int, play_time: float, UCI_LimitStrength: bool, UCI_Elo: int):
        self._skill_level = skill_level
        self._play_time = play_time
        self._UCI_LimitStrength = UCI_LimitStrength
        self._UCI_Elo = UCI_Elo
        # If getting started, you need to run brew install stockfish
        self._engine = chess.engine.SimpleEngine.popen_uci("stockfish")

    def get_move(
        self, board: chess.Board, game_state: str, temperature: float
    ) -> Optional[str]:
        self._engine.configure({"Skill Level": self._skill_level})
        self._engine.configure({"UCI_LimitStrength": self._UCI_LimitStrength})
        self._engine.configure({"UCI_Elo": self._UCI_Elo})
        result = self._engine.play(board, chess.engine.Limit(time=self._play_time))
        if result.move is None:
            return None
        return board.san(result.move)

    def get_config(self) -> dict:
        return {"skill_level": self._skill_level, "play_time": self._play_time, "UCI_LimitStrength": self._UCI_LimitStrength, "UCI_Elo": self._UCI_Elo}

    def close(self):
        self._engine.quit()


def get_gpt_response(game_state: str, model: str, temperature: float) -> Optional[str]:
    # pause for throttling rate to keep below openai limit (current Limit: 3 requests per min): time.sleep(31.3) 
    # trying to prevent what I believe to be rate limit issues
    if model == "gpt-4":
        time.sleep(0.4)
    response = gpt_query.get_gpt_response(game_state, model, temperature)
    return response


def get_move_from_gpt_response(response: Optional[str]) -> Optional[str]:
    if response is None:
        return None

    # Parse the response to get only the first move
    moves = response.split()
    first_move = moves[0] if moves else None

    return first_move


def record_results(
    board: chess.Board,
    player_one: Player,
    player_two: Player,
    game_state: str,
    player_one_illegal_moves: int,
    player_two_illegal_moves: int,
    total_time: float,
    player_one_resignation: bool,
    player_two_resignation: bool,
    player_one_failed_to_find_legal_move: bool,
    player_two_failed_to_find_legal_move: bool,
):
    unique_game_id = generate_unique_game_id()

    player_one_title, player_two_title = get_player_titles(player_one, player_two)

    if player_one_resignation or player_one_failed_to_find_legal_move:
        result = "0-1"
        player_one_score = 0
        player_two_score = 1
    elif player_two_resignation or player_two_failed_to_find_legal_move:
        result = "1-0"
        player_one_score = 1
        player_two_score = 0
    else:
        result = board.result()
        # Hmmm.... debating this one. Annoying if I leave it running and it fails here for some reason, probably involving some
        # resignation / failed move situation I didn't think of
        # -1 at least ensures it doesn't fail silently
        if "-" in result:
            player_one_score = result.split("-")[0]
            player_two_score = result.split("-")[1]
        else:
            player_one_score = -1
            player_two_score = -1

    info_dict = {
        "game_id": unique_game_id,
        "transcript": game_state,
        "result": result,
        "player_one": player_one_title,
        "player_two": player_two_title,
        "player_one_score": player_one_score,
        "player_two_score": player_two_score,
        "player_one_illegal_moves": player_one_illegal_moves,
        "player_two_illegal_moves": player_two_illegal_moves,
        "player_one_resignation": player_one_resignation,
        "player_two_resignation": player_two_resignation,
        "player_one_failed_to_find_legal_move": player_one_failed_to_find_legal_move,
        "player_two_failed_to_find_legal_move": player_two_failed_to_find_legal_move,
        "game_title": f"{player_one_title} vs. {player_two_title}",
        "number_of_moves": board.fullmove_number,
        "time_taken": total_time,
    }

    csv_file_path = "logs/games.csv"

    # Determine if we need to write headers (in case the file doesn't exist yet)
    write_headers = not os.path.exists(csv_file_path)

    # Append the results to the CSV file
    with open(csv_file_path, "a", newline="") as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=info_dict.keys())
        if write_headers:
            writer.writeheader()
        writer.writerow(info_dict)

    with open("game.txt", "w") as f:
        f.write(game_state)


def generate_unique_game_id() -> str:
    timestamp = int(time.time())
    random_num = random.randint(1000, 9999)  # 4-digit random number
    return f"{timestamp}-{random_num}"


def get_player_titles(player_one: Player, player_two: Player) -> Tuple[str, str]:
    player_one_config = player_one.get_config()
    player_two_config = player_two.get_config()

    # For player one
    if "model" in player_one_config:
        player_one_title = player_one_config["model"]
    else:
        if player_one_config['UCI_LimitStrength']: # is the UCI_Elo parameter active?
            player_one_title = (f"Stockfish_PlayTime={player_one_config['play_time']}_"
                            f"UCI_Elo={player_one_config['UCI_Elo']}")
        else: # UCI_Elo parameter is inactive!
            player_one_title = (f"Stockfish_PlayTime={player_one_config['play_time']}_"
                            f"SkillLevel={player_one_config['skill_level']}_"
                            f"UCI_LimitStrength={player_one_config['UCI_LimitStrength']}")

    # For player two
    if "model" in player_two_config:
        player_two_title = player_two_config["model"]
    else:
        if player_two_config['UCI_LimitStrength']: # is the UCI_Elo parameter active?
            player_two_title = (f"Stockfish_PlayTime={player_two_config['play_time']}_"
                            f"UCI_Elo={player_two_config['UCI_Elo']}")
        else: # UCI_Elo parameter is inactive!
            player_two_title = (f"Stockfish_PlayTime={player_two_config['play_time']}_"
                            f"SkillLevel={player_two_config['skill_level']}_"
                            f"UCI_LimitStrength={player_two_config['UCI_LimitStrength']}")

    return (player_one_title, player_two_title)


# Return is (move_san, move_uci, attempts, is_resignation, is_illegal_move)
def get_legal_move(
    player: Player,
    board: chess.Board,
    game_state: str,
    player_one: bool,
    max_attempts: int = 5,
) -> LegalMoveResponse:
    """Request a move from the player and ensure it's legal."""
    move_san = None
    move_uci = None

    for attempt in range(max_attempts):
        move_san = player.get_move(
            board, game_state, ((attempt / max_attempts) * 0.5) + 0.3
        )

        # Sometimes when GPT thinks it's the end of the game, it will just output the result
        # Like "1-0". If so, this really isn't an illegal move, so we'll add a check for that.
        if move_san is not None:
            if move_san == "1-0" or move_san == "0-1" or move_san == "1/2-1/2":
                print(f"{move_san}, player has resigned")
                return LegalMoveResponse(
                    move_san=None,
                    move_uci=None,
                    attempts=attempt,
                    is_resignation=True,
                )

        try:
            move_uci = board.parse_san(move_san)
        except Exception as e:
            print(f"Error parsing move {move_san}: {e}")
            # check if player is gpt-3.5-turbo-instruct
            # only recording errors for gpt-3.5-turbo-instruct because it's errors are so rare
            if player.get_config()["model"] == "gpt-3.5-turbo-instruct":
                with open("gpt-3.5-turbo-instruct-illegal-moves.txt", "a") as f:
                    f.write(f"{game_state}\n{move_san}\n")
            continue

        if move_uci in board.legal_moves:
            if player_one == False:
                if not move_san.startswith(" "):
                    move_san = " " + move_san
            else:
                if move_san.startswith(" "):
                    move_san = move_san[1:]
            return LegalMoveResponse(move_san, move_uci, attempt)
        print(f"Illegal move: {move_san}")

    # If we reach here, the player has made illegal moves for all attempts.
    print(f"{player} provided illegal moves for {max_attempts} attempts.")
    return LegalMoveResponse(
        move_san=None, move_uci=None, attempts=max_attempts, is_illegal_move=True
    )


def play_turn(
    player: Player, board: chess.Board, game_state: str, player_one: bool
) -> Tuple[str, bool, bool, int]:
    result = get_legal_move(player, board, game_state, player_one)
    illegal_moves = result.attempts
    move_san = result.move_san
    move_uci = result.move_uci
    resignation = result.is_resignation
    failed_to_find_legal_move = result.is_illegal_move

    if resignation:
        print(f"{player} resigned with result: {board.result()}")
    elif failed_to_find_legal_move:
        print(f"Game over: 5 consecutive illegal moves from {player}")
    elif move_san is None or move_uci is None:
        print(f"Game over: {player} failed to find a legal move")
    else:
        board.push(move_uci)
        game_state += move_san
        print(move_san, end=" ")

    return game_state, resignation, failed_to_find_legal_move, illegal_moves


def play_game(player_one: Player, player_two: Player, max_games: int = 10):
    for _ in range(max_games):  # Play 10 games
        with open("gpt_inputs/prompt.txt", "r") as f:
            game_state = f.read()
        board = chess.Board()
        player_one_illegal_moves = 0
        player_two_illegal_moves = 0
        player_one_resignation = False
        player_two_resignation = False
        player_one_failed_to_find_legal_move = False
        player_two_failed_to_find_legal_move = False
        start_time = time.time()
        while not board.is_game_over():
            with open("game.txt", "w") as f:
                f.write(game_state)
            current_move_num = str(board.fullmove_number) + "."

            # this if statement may be overkill, just trying to get format to exactly match PGN notation
            if board.fullmove_number != 1:
                game_state += " "
            game_state += current_move_num
            print(f"{current_move_num}", end=" ")

            (
                game_state,
                player_one_resignation,
                player_one_failed_to_find_legal_move,
                illegal_moves_one,
            ) = play_turn(player_one, board, game_state, player_one=True)
            player_one_illegal_moves += illegal_moves_one
            if (
                board.is_game_over()
                or player_one_resignation
                or player_one_failed_to_find_legal_move
            ):
                break

            (
                game_state,
                player_two_resignation,
                player_two_failed_to_find_legal_move,
                illegal_moves_two,
            ) = play_turn(player_two, board, game_state, player_one=False)
            player_two_illegal_moves += illegal_moves_two
            if (
                board.is_game_over()
                or player_two_resignation
                or player_two_failed_to_find_legal_move
            ):
                break
            # pause for throttling rate to keep below openai limit (current Limit: 3 requests per min): time.sleep(31.3) 

            print("\n", end="")

        end_time = time.time()
        total_time = end_time - start_time
        print(f"\nGame over. Total time: {total_time} seconds")
        print(f"Result: {board.result()}")
        print(board)
        print()
        record_results(
            board,
            player_one,
            player_two,
            game_state,
            player_one_illegal_moves,
            player_two_illegal_moves,
            total_time,
            player_one_resignation,
            player_two_resignation,
            player_one_failed_to_find_legal_move,
            player_two_failed_to_find_legal_move,
        )
    if isinstance(player_one, StockfishUCIElo):
        player_one.close()
    if isinstance(player_two, StockfishUCIElo):
        player_two.close()

        # print(game_state)


if __name__ == "__main__":
    #with open("/var/chess/OPENAI-api_key.txt", "r") as f:        openai.api_key = f.read().strip()

    # scaling times for real rated strength
    # Stockfish internal ELo ratings are described at <https://github.com/vondele/Stockfish/commit/a08b8d4e9711c2>
    # Elo rating has been calibrated at a time control of 60s+0.6sec and anchored to CCRL 40/4min.
    # In turn, CCRL 40/4min was a fast time control setup ("Blitz", which currently applies even shorter times).
    # Full playing strength is not reached until longer times are used, at least 40/15min.
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
    #"loop-bench-10core_HEREDOC.sh_Loop_count=10_nCPU=10.bench.stderr","median Nodes/second from 10 benchmark runs",  9887948, "10-core!" 
    nps_localhost10CPU=9887948
    
    for i in range(1): #<<set for set of skill_level values
        num_games = 1 #<<increase
        player_one = StockfishUCIElo(skill_level=i, play_time=0.1 *nps_M1Mac10CPU/nps_localhost10CPU, UCI_LimitStrength=False, UCI_Elo=1800)
        # player_one = GPTPlayer(model="gpt-4")
        # give fixed time/move equivalent to CCRL 40/4min
        player_two = StockfishUCIElo(skill_level=4, play_time=4*60/40*0.72614410905550146056, UCI_LimitStrength=True, UCI_Elo=1800)
        # player_two = GPTPlayer(model="gpt-4")
        # player_two = GPTPlayer(model="gpt-3.5-turbo-instruct")
        play_game(player_one, player_two, num_games)
        # and with reversed colors!
        player_two = StockfishUCIElo(skill_level=i, play_time=0.1 *nps_M1Mac10CPU/nps_localhost10CPU, UCI_LimitStrength=False, UCI_Elo=1800)
        # give fixed time/move equivalent to CCRL 40/4min
        player_one = StockfishUCIElo(skill_level=4, play_time=4*60/40*0.72614410905550146056, UCI_LimitStrength=True, UCI_Elo=1800)
        play_game(player_one, player_two, num_games)
        # play_game(player_two, player_one, num_games)

