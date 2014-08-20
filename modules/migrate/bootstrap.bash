#!/bin/bash

#################################################
# Config
#################################################
. ./config/database_config.bash
. ./config/migrate_config.bash

#################################################
# Libs
#################################################
. ./lib/mysql.bash
. ./lib/migrate.bash

#################################################
# Dispatch
#
# @param $1: The action to take
# @param $2+: Any additional params to pass to
#             the action
#################################################
Migrate_dispatch() {
    if   [ "$1" = "migrate" ]; then
        Migrate__index
    elif [ "$1" = "migrate:update" ]; then
        Migrate__update
    elif [ "$1" = "migrate:make" ]; then
        Migrate__make $2
    elif [ "$1" = "migrate:rollback" ]; then
        Migrate__rollback
    elif [ "$1" = "migrate:reset" ]; then
        Migrate__reset
    elif [ "$1" = "migrate:refresh" ]; then
        Migrate__refresh
    elif [ "$1" = "migrate:map" ]; then
        Migrate__map
    elif [ "$1" = "migrate:step" ]; then
        Migrate__step $2
    else
        Logger__error "Action invalid"
    fi
}

#################################################
# Start
#################################################
# Checking that we're not in production
if [ $Migrate__app_in_production -eq 1 ]; then
    Logger__error "Warning, this application is in production"
    Logger__prompt "Continue?  (Y/n): "

    read input
    input=$(echo $input | awk '{print tolower($0)}')
    if [ "$input" != "y" ] && [ "$input" != "yes" ]; then
        Logger__alert "Exiting"
        exit
    fi
fi

# Making sure the DB is set up
Migrate__ensure_setup

# Checking if we should always update
if [ $Migrate__always_update -eq 1 ]; then
    Migrate__update
fi

# Dispatching action
Migrate_dispatch "$@"

