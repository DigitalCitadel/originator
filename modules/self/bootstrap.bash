#!/bin/bash
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
Self_dispatch() {
    if [ "$1" = "self:init" ]; then
        Self__init
    else
        Logger__error "Action invalid"
    fi
}

#################################################
# Start
#################################################
Self_dispatch "$@"

