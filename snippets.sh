#!/bin/bash

#******************************************************************************#
# Snippets for Bash scripting.
#******************************************************************************#

#******************************************************************************#
# Save the state of the terminal and restor it afterwards.
#******************************************************************************#
tput smcup # Save the state and clear the terminal.
clear

# Do stuff
read -n1 -p "Press any key to continue..." var

tput rmcup # Restore the state.
echo "You pressed \"$var\""

#******************************************************************************#
# Check the number of arguments passed to a function.
#******************************************************************************#
ARG_COUNT=1
if [ $# -ne $ARG_COUNT ]; then
    echo "Usage: $FUNCNAME arg"     # for function name
    echo "Usage: `basename $0` arg" # for script name
fi

#******************************************************************************#
# Check if line does NOT already exist in file.
#******************************************************************************#
SEARCH_TERM="Something to search for."
FILE_NAME=~/.bashrc
if ! grep -q $SEARCH_TERM $FILE_NAME; then
    echo "do stuff"
fi

#******************************************************************************#
# Parse command line options.
#******************************************************************************#
while getopts ":a:bc" opt; do
#              ^ ^ second colon indicates that option -a takes an argument
#              ^ first colon suppresses getopts errors
    case $opt in
        a)
            echo "Option -a was triggered, parameter: $OPTARG" >&2
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            ;;
        b)
            echo "Option b was triggered."
            ;;
        c)
            echo "Option c was triggered."
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

# You can just shift the options off the input args.
shift $((OPTIND-1))

# And reference the new arg list as normal.
echo $@

#******************************************************************************#
# Verbose printing function.
#
# Usage:
#     verbose "string to print" [1|2|3|...]
#
# Will print the supplied string if the specified number of -v options have been
#   passed into the script.
#
# Requires option parsing:
#
#     case $opt in
#         v)
#             ((verbosity=verbosity+1))
#******************************************************************************#
verbose()
{
    num_vs=$2
    ((num_vs=num_vs+1))
    if [[ verbosity -gt num_vs ]]; then
        echo $1
    fi
}

#******************************************************************************#
# Check the return value of a function.
#******************************************************************************#
testfunc() {
    return 4
}
testfunc
if [[ $? -eq 4 ]]; then
    echo "returned 4"
fi

#******************************************************************************#
# Loop over files in multiple directories.
#******************************************************************************#
for file in /{,usr/}bin/*
#             ^    matches '' or 'usr/' to look in /bin and /usr/bin directories.
do
    if [ -x "$file" ]
    then
        echo $file
    fi
done

#******************************************************************************#
# Check for a valid IPv4 address.
#******************************************************************************#
IP="192.168.0.1"
if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "$IP is a valid IPv4 address."
fi

#******************************************************************************#
# Echo string into a root owned file.
#******************************************************************************#
STRING="Something, maybe about hosts"
FILE=~/tmp/someFile
echo $STRING | sudo tee -a $FILE
