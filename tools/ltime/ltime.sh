#!/bin/bash
#
# Print the current elapsed time of a command every second.

BLUE='\033[1;34m'
NC='\033[0m' # No Color

n=5

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

arg_count=1
if [ $# -lt "$arg_count" ]; then
    echo "Usage: `basename $0` [command]"
fi

time_loop &
loop_id=$!

"$@"

kill $loop_id
