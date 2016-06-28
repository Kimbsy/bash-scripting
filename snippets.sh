#!/bin/bash

# Snippets for Bash scripting.

# Check if line does NOT already exist in file.
# 
# Super useful for install scripts where you want to add a line to ~/.bashrc if
#   this is the first time the script has been run.
SEARCH_TERM="Something to search for."
FILE_NAME="~/.bashrc"
if ! grep -q $SEARCH_TERM $FILE_NAME; then
    echo "do stuff"
fi

# Check the number of arguments passed to a function.
ARG_COUNT=1
if [ $# -ne $ARG_COUNT]; then
    echo "Usage: $FUNCNAME arg"
fi

# Check the return value of a function.
#
# There may be a better way of doing this.
testfunc() {
    return 4
}
testfunc
if [[ $? -eq 4 ]]; then
    echo "returned 4"
fi
