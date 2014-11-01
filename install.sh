#!/bin/bash
cd "$(dirname "$0")"

# Including logger
. lib/logger.bash

# Displaying all the install locations
Logger__alert "Originator can be installed to any of these locations:"
counter=1
IFS=':' read -ra ADDR <<< "$PATH"
for i in "${ADDR[@]}"; do
    Logger__log "[$counter]: $i"
    locations[$counter]=$i
    (( counter++ ))
done

# Getting the install location
Logger__prompt "Enter the number for location to install and press [ENTER]: "
read install_number
install_location=${locations[$install_number]}

# Exiting if invalid input
if [[ $install_location = "" ]]; then
    Logger__error "Invalid input, exiting"
    exit
fi

# Getting current + new directories
current_location_full=$(pwd)
current_location=${PWD##*/}
new_location="/etc/$current_location"

# Moving originator /etc
sudo mv $current_location_full $new_location

# Creating symlink
cd "$install_location"
ln -s "$new_location/originator" .

