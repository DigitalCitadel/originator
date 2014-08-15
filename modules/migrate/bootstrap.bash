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
# Start
#################################################
# Checking that we're not in production
if [ $Migrate__app_in_production -eq 1 ]; then
    Logger__error "Warning, this application is in production."
    Logger__prompt "Continue?  (Y/n): "

    read input
    input=$(echo $input | awk '{print tolower($0)}')
    if [ "$input" != "y" ] && [ "$input" != "yes" ]; then
        Logger__alert "Exiting"
        exit
    fi
fi

# Making sure the DB is set up
ensure_setup

# Checking if we should always update
if [ $Migrate__always_update -eq 1 ]; then
    migrate_update
fi

# Figuring out what action to run
determine_action "$@"

