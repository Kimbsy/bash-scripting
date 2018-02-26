#!/bin/bash

name=fleet

echo "Installing $name tool..."

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    echo "Removing previous version..."
    sudo rm "$binary"
fi
sudo ln -s "$(pwd)/$name" "$binary"

opt_dir="/opt/$(whoami)/bash/$name"
if [ ! -f "$opt_dir" ]; then
    sudo mkdir -p "$opt_dir"
    sudo chmod -R 755 "/opt/$(whoami)"
fi

# Copy parsers for individual sites.
sudo cp "$(pwd)/eve_online_ships" "$opt_dir/"

echo "Installation complete."
