#!/usr/bin/gawk -f
# extract pgn_transcript data from CSV in <https://github.com/adamkarvonen/chess_gpt_eval/logs>
# NOTE the repo has Mac text files, with CRLF (\r\n) line endings
# make this code detect, and handle, either CRLF or LF (Unix) line endings

#BEWARE these CSV files have weirdly embedded newlines
#BEWARE^2 doubled "" present in old output, plus lots of PGN tags
#	AND the following malformed ones:
#[BlackFideId""4168119""]
#[TimeControl40/7200:20/3600:900+30""]


# Define a function to retrieve the file's creation date
function get_birthtime(file) {
    # Use the 'stat' command to retrieve file attributes
    cmd = "stat -c %w " file
    cmd | getline birthtime
    close(cmd)
    return birthtime
}

BEGIN {
    FS=","
    moves_in_pgn_transcript=4
    
    #print "path of input FILE:", ARGV[1] -- won't work well with the relative path intended to use
    #print "file_path: ", file_path
}

BEGINFILE {
    intGameNumber = 0
    #intMoveNumber = 0
    # retrieve the creation date
    creation_date = get_birthtime(FILENAME)
    # Print the creation date
    #print "Creation date of", FILENAME, "is:", FILENAME
}

{
    # Replace doubled double quotes with a single double quote
    gsub(/""/, "\"", $0)	#	 fix doubled "" present in old output
}

(FNR==1){
    #1st, detect whether the input file has CRLF (\r\n) line endings 
    if (sub(/\r$/, "")) {
        line_ending = "CRLF"
        RS = "\r\n" 
    } else {
        line_ending = "LF"
        RS = "\n" 
    }
    #print "Detected line ending style: " line_ending

    for (i = 1; i <= NF; i++) {
        header_field_pointer[$i]=i
        header_field[i]=$i
        #print "TRACK header_field_pointer[" $i "]=" header_field_pointer[$i]
    }
}

(FNR>1){
    ++intGameNumber
    #PGN: 7 primary tags 
    print "" # extra newline, to make sure games are separated in PGN output
    print "[Event \"Python computer chess tournament for Stockfish strength testing\"]"
    print "[Site \"" file_path " @localhost\"]"
    print "[Date \"" creation_date "\"]"
    print "[Round \"" intGameNumber "\"]"
    print "[White \"" $(header_field_pointer["player_one"]) "\"]"
    print "[Black \"" $(header_field_pointer["player_two"]) "\"]"
    print "[Result \"" $(header_field_pointer["result"]) "\"]"
    
    #PGN: custom tags 
    print "[game_id \"" $(header_field_pointer["game_id"]) "\"]"
    print "[player_one_failed_to_find_legal_move \"" $(header_field_pointer["player_one_failed_to_find_legal_move"]) "\"]"
    print "[player_one_illegal_moves \"" $(header_field_pointer["player_one_illegal_moves"]) "\"]"
    print "[player_two_failed_to_find_legal_move \"" $(header_field_pointer["player_two_failed_to_find_legal_move"]) "\"]"
    print "[player_two_illegal_moves \"" $(header_field_pointer["player_two_illegal_moves"]) "\"]"
    print "[player_one_resignation \"" $(header_field_pointer["player_one_resignation"]) "\"]"
    print "[player_two_resignation \"" $(header_field_pointer["player_two_resignation"]) "\"]"
    print "[time_taken \"" $(header_field_pointer["time_taken"]) " seconds\"]"
    
    #for (i = 1; i <= NF; i++) { field[i]=$i }
    #transcript
    pgn_transcript=$(header_field_pointer["transcript"])
    #print "\n\tTRACK intGameNumber="intGameNumber"., 'pgn_transcript=$(" header_field_pointer["transcript"] ")':'\n\t'" pgn_transcript "'\n"
    Nparts_pgn_transcript=split(pgn_transcript, parts_pgn_transcript, "\n")
    moves=parts_pgn_transcript[moves_in_pgn_transcript]
    # Use regular expression to match and print multi-digit numbers
    Ngsub=gsub(/[0-9]+\./, "\n& ", moves)
    #print "\n\tTRACK intGameNumber="intGameNumber"., Ngsub="Ngsub"\nmoves='" moves "'"
    #print ""
    #'moves' starts with newline
    gsub(/"/, "", moves)
    print moves
    print ""

}

