#!/bin/bash
#################################################
# Libs
#################################################
Originator__autoload lib

#################################################
# Dispatch
#
# @param $1: The action to take
# @param $2+: Any additional params to pass to
#             the action
#################################################
Backup_dispatch() {
    if   [ "$1" = "backup" ]; then
        Backup__index
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

