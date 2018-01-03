#!/bin/bash

name=getdeck

echo "Installing $name tool..."

sudo apt-get -qq install -y xclip phantomjs

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    echo "Removing previous version..."
    sudo rm "$binary"
fi
sudo ln -s "$(pwd)/$name" "$binary"

opt_dir="/opt/kimbsy/bash/$name"
if [ ! -f "$opt_dir" ]; then
    sudo mkdir -p "$opt_dir"
fi

# Copy parsers for individual sites.
sudo cp "$(pwd)/getdeck_from_"* "$opt_dir/"
sudo chmod +x "$opt_dir/"*

# Copy phantomJS script for allowing decklists to load.
sudo cp "$(pwd)/getLoadedSource.js" "$opt_dir/"

echo "Installation complete."
