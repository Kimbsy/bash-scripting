#!/bin/bash
#
# Snippets for Bash scripting.

################################################################################
# Check if line does NOT already exist in file.
################################################################################
SEARCH_TERM="Something to search for."
FILE_NAME=~/.bashrc
if ! grep -q $SEARCH_TERM $FILE_NAME; then
    echo "do stuff"
fi

################################################################################
# Check the number of arguments passed to a function.
################################################################################
ARG_COUNT=1
if [ $# -ne $ARG_COUNT ]; then
    echo "Usage: $FUNCNAME arg"     # for function name
    echo "Usage: `basename $0` arg" # for script name
fi

################################################################################
# Check the return value of a function.
################################################################################
testfunc() {
    return 4
}
testfunc
if [[ $? -eq 4 ]]; then
    echo "returned 4"
fi

################################################################################
# Loop over files in multiple directories.
################################################################################
for file in /{,usr/}bin/*
#             ^    matches '' or 'usr/' to look in /bin and /usr/bin directories.
do
    if [ -x "$file" ]
    then
        echo $file
    fi
done

################################################################################
# Check for a valid IPv4 address.
################################################################################
IP="192.168.0.1"
if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "$IP is a valid IPv4 address."
fi

################################################################################
# Echo string into a root owned file.
################################################################################
STRING="Something, maybe about hosts"
FILE=~/tmp/someFile
echo $STRING | sudo tee -a $FILE
