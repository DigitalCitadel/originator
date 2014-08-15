#!/bin/bash

#################################################
# Config
#################################################
. ./config/database_config.bash
. ./config/originator_config.bash

#################################################
# Libs
#################################################
. ./lib/logger.bash
. ./lib/mysql.bash
. ./lib/migrate.bash

#################################################
# Start
#################################################
# Checking that we're not in production
if [ $APP_IN_PRODUCTION -eq 1 ]; then
    log_error "Warning, this application is in production."
    log_alert "Are you sure you want to continue?  (Y/n)"

    read input
    input=$(echo $input | awk '{print tolower($0)}')
    if [ "$input" != "y" ] && [ "$input" != "yes" ]; then
        log_alert "Exiting"
        exit
    fi
fi

# Making sure the DB is set up
ensure_setup

# Checking if we should always update
if [ $ALWAYS_UPDATE -eq 1 ]; then
    migrate_update
fi

# Figuring out what action to run
determine_action "$@"

