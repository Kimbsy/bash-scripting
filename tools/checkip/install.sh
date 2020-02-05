#!/bin/bash

name=checkip

echo "Installing $name tool..."

sudo apt-get -qq install -y xclip

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

ip_file="$opt_dir/ip"
sudo touch "$ip_file"
sudo chmod 666 "$ip_file"

echo "Installation complete."
