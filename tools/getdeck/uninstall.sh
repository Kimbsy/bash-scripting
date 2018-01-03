#!/bin/bash

name=getdeck

echo "Uninstalling $name tool..."

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    sudo rm "$binary"
fi

opt_dir="/opt/kimbsy/bash/$name"
if [ -d "$opt_dir" ]; then
    sudo rm -rf "$opt_dir"
fi
