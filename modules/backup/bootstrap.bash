#!/bin/bash

# Checking if this is an initialized directory
Originator__check_init

#################################################
# Libs
#################################################
Originator__autoload "$Originator__module_directory"/lib

#################################################
# Dispatch
#
# @param $1: The action to take
# @param $2+: Any additional params to pass to
#             the action
#################################################
Backup_dispatch() {
    if   [ "$1" = "backup" ]; then
        Backup__index $2
    elif [ "$1" = "backup:restore" ]; then
        Backup__restore $2
    elif [ "$1" = "backup:map" ]; then
        Backup__map
    else
        Logger__error "Action invalid"
    fi
}

# Dispatching action
Backup_dispatch "$@"

