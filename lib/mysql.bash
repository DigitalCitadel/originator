#!/bin/bash

#################################################
# Executes a database statement
#
# @param $1: the statement to be executed
#################################################
database_execute() {
    mysql   --user="$MYSQL_USER" \
            --password="$MYSQL_PASS" \
            --database="$MYSQL_DATABASE" \
            --execute="$1"
}

#################################################
# Check if a database table exists
#
# @param $1: the table to check existence
#################################################
database_table_exists() {
    var=$(database_execute "SHOW TABLES LIKE '$1'")
    if [ "$var" = "" ]; then
        return 0
    else
        return 1
    fi
}

