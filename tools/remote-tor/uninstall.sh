#!/bin/bash

name=remote-tor

binary="/usr/local/bin/$name"
if [ ! -f  "$binary" ]; then
    echo "No installed version of $name found."
    exit 1
else
    echo "Uninstalling $name tool..."
    sudo rm "$binary"
fi
