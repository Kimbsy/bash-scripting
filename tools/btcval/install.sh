#!/bin/bash

name=btcval

echo "Installing $name tool..."

sudo apt-get -qq install -y jq

binary="/usr/local/bin/$name"
if [ -f  "$binary" ]; then
    echo "Removing previous version..."
    sudo rm "$binary"
fi
sudo ln -s "$(pwd)/$name" "$binary"

echo "Creating keyboard shortcut for $name..."

# check if btcval shortcut already exists
bindings="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
existing=$(dconf dump "$bindings/" | grep -oP "name='\K[^']+")
if echo "$existing" | grep -q "$name"; then
  echo "Shortcut for $name already exists."
else
  # get the next unused shortcut index
  last_index=$(dconf list "$bindings/" | grep -oP "\d+" | sort | tail -n 1)
  new_index=$((last_index + 1))

  # create the shortcut
  dconf write "$bindings/custom$new_index/name" "'$name'"
  dconf write "$bindings/custom$new_index/command" "'$name'"
  dconf write "$bindings/custom$new_index/binding" "'<Primary><Shift><Alt>b'"

  # add the shortcut
  acc_str="["
  for b in $(dconf list "$bindings/"); do
    acc_str="$acc_str'$bindings/$b', "
  done
  val="${acc_str%%, }]"
  dconf write "$bindings" "$val"
fi

echo "Installation complete."
