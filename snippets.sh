#!/bin/bash

#******************************************************************************#
# Snippets for Bash scripting.
#******************************************************************************#

#******************************************************************************#
# Iterate over array values.
#******************************************************************************#
my_array=(thing1 thing2 thing3)
for var in "${my_array[@]}"
do
  echo "${var}"
done

#******************************************************************************#
# Read lines from file.
#******************************************************************************#
while read -r line; do
    echo "$line"
done < /input/file_name

#******************************************************************************#
# Split string into array by delimiter.
#******************************************************************************#
IFS=';' read -r -a array_name <<< "$some_string"

#******************************************************************************#
# Save the state of the terminal and restore it afterwards.
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
arg_count=1
if [ $# -ne "$arg_count" ]; then
    echo "Usage: $FUNCNAME arg"     # for function name
    echo "Usage: `basename $0` arg" # for script name
fi

#******************************************************************************#
# Check if line does NOT already exist in file.
#******************************************************************************#
search_term="Something to search for."
file_name="~/.bashrc"
if ! grep -q "$search_term" "$file_name"; then
    echo "do stuff"
fi

#******************************************************************************#
# Parse command line options.
#******************************************************************************#
while getopts ":a:bc" opt; do
#              ^ ^ second colon indicates that option -a takes an argument
#              ^ first colon suppresses getopts errors
    case "$opt" in
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
verbose() {
    num_vs=$2
    ((num_vs=num_vs+1))
    if [[ $verbosity -gt num_vs ]]; then
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
ip="192.168.0.1"
if [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "$ip is a valid IPv4 address."
fi

#******************************************************************************#
# Echo string into a root owned file.
#******************************************************************************#
string="Something, maybe about hosts"
destination="~/tmp/someFile"
echo "$string" | sudo tee -a "$destination"

#******************************************************************************#
# Color output.
#
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
#******************************************************************************#

RED='\033[0;31m'
NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"

#******************************************************************************#
# Uppercase first letter.
#******************************************************************************#
ucfirst() {
    for word in "$@"; do
        first=${word:0:1}
        rest=${word:1}
        echo "${first^^}$rest"
    done
}

# Basic usage
ucfirst "uppercase"

# Takes any number of args
ucfirst "one two three" "four" "five"

# Can even take arrays
some_array=("foo" "bar" "baz")
ucfirst ${some_array[@]}

# Interpolation
name="dave"
echo "Hello my name is $(ucfirst $name)"
