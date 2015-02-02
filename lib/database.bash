#!/bin/bash

#################################################
# Loads the appropriate database driver handles
# all other setup operations
#################################################
Database__setup() {
    # Loading the appropriate database driver
    if [[ "$Database__driver" = 'mysql' ]]; then
        . "$Originator__lib_directory"/lib/database_drivers/mysql.bash
        Mysql__generate_config
    elif [[ "$Database__driver" = 'postgres' ]]; then
        . "$Originator__lib_directory"/lib/database_drivers/postgres.bash
    fi
}


#################################################
# Shuts down the database
#################################################
Database__shutdown() {
    # Removing the config file
    if [[ "$Database__driver" = 'mysql' ]]; then
        Mysql__delete_config
    fi
}

