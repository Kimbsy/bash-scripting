#!/bin/bash
#
# Script to convert current copy buffer text and run it through json prettifier.
# 
# Intended for use as a keyboard shortcut.

xclip -selection clipboard -o | python -m json.tool | xclip -selection c
notify-send "JSON prettified" "Current copy buffer converted"
