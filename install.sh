#!/bin/bash
cd "$(dirname "$0")"

# Including logger
. lib/logger.bash

# Getting current + new directories
current_location_full=$(pwd)
current_location=${PWD##*/}
new_location="/etc/$current_location"

# Logging install location
Logger__alert "Installing in $new_location"

# Moving originator /etc
sudo mv $current_location_full $new_location

# Creating symlink
install_location="/usr/local/bin"
cd "$install_location"
ln -s "$new_location/originator" .

