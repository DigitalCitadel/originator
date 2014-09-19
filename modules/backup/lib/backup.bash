#!/bin/bash

#################################################
# Backs up the entire database
#################################################
Backup__index() {
    echo "Backup__index"
}

#################################################
# Restores an entire database
#
# @param $1: The timestamp of the backup.
# This is also the folder name in the backups 
# directory
#################################################
Backup__restore() {
    if [[ -z "$1" ]]; then
        Logger__error "backup:restore requires a second parameter for the timestamp of the backup."
    else
        echo "Backup__restore $1"
    fi
}

