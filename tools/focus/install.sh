#!/bin/bash

name=focus

echo "Installing $name tool..."

sudo apt-get -qq install -y xdotool

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    echo "Removing previous version..."
    sudo rm "$binary"
fi
sudo ln -s "$(pwd)/$name" "$binary"

echo "Installation complete."
