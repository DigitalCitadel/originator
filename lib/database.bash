#!/bin/bash

#################################################
# Loads the appropriate database driver handles
# all other setup operations
#################################################
Database__setup() {
    # Loading the appropriate database driver
    if [[ "$Database__driver" = 'mysql' ]]; then
        . "$Originator__lib_directory"/lib/database_drivers/mysql.bash
        Database__generate_config
    fi
}


#################################################
# Shuts down the database
#################################################
Database__shutdown() {
    # Loading the appropriate database driver
    if [[ "$Database__driver" = 'mysql' ]]; then
        Database__delete_config
    fi
}

