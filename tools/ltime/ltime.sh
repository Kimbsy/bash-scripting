#!/bin/bash
#
# Print the current elapsed time of a command.

BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Nuber of seconds between outputs.
n=5

#******************************************************************************#
# This loop runs as a background process and prints the time in minutes and
#   seconds.
#******************************************************************************#
time_loop() {
    seconds=0
    minutes=0
    while :; do
        sleep $n
        ((seconds=seconds+n))
        
        if [[ $seconds -gt 59 ]]; then
            ((minutes=minutes+1))
            seconds=0
        fi

        printf "${BLUE}[%d:%02d]${NC}\n" $minutes $seconds
    done
}

# Ensure we have at least one argument.
arg_count=1
if [ $# -lt "$arg_count" ]; then
    echo "Usage: `basename $0` [command]"
fi

# Start the timer loop and store its process id.
time_loop &
loop_id=$!

# Execute the command.
"$@"

# Stop the timer loop.
kill $loop_id
