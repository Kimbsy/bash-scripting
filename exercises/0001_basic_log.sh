#!/bin/bash

# Basic loggin script.
# 
# Show the time and date, list all logged-in users and give the system uptime,
#   then log all of these to a file.

# Time and date.
DATE=$(date)
echo $DATE

# Logged-in users.
USERS=$(users)
echo $USERS

# System uptime
UPTIME=$(uptime)
echo $UPTIME

# Log to file.
echo $DATE >> /tmp/0001.log
echo $USERS >> /tmp/0001.log
echo $UPTIME >> /tmp/0001.log
