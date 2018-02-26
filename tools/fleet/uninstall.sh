#!/bin/bash

name=fleet

echo "Uninstalling $name tool..."

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    sudo rm "$binary"
fi

opt_dir="/opt/$(whoami)/bash/$name"
if [ -d "$opt_dir" ]; then
    sudo rm -rf "$opt_dir"
fi
