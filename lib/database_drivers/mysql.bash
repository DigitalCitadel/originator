#!/bin/bash

# Temporary config file location
Mysql__config_file="$Originator__config_directory/mysql_config.cnf"

#################################################
# Executes a database statement
#
# @param $1: the statement to be executed
#################################################
Mysql__execute() {
    "$Database__mysql_path" \
        --defaults-extra-file="$Mysql__config_file" \
        --database="$Database__mysql_database" \
        --execute="$1"
}

#################################################
# Executes a database statement and
# gives the output
#
# @param $1: the statement to be executed
#################################################
Mysql__fetch() {
    "$Database__mysql_path" \
        --defaults-extra-file="$Mysql__config_file" \
        --silent \
        --skip-column-names \
        --batch \
        --database="$Database__mysql_database" \
        --execute="$1"
    echo "$out"
}

#################################################
# Generates the MySQL config file to be used
#
# This is to be created + destoyed in the span
# of one command
#################################################
Mysql__generate_config() {
    # Deleting old mysql config file if it existed
    Mysql__delete_config

    # Creating new MySQL config file
    touch "$Mysql__config_file"
    chmod 600 "$Mysql__config_file"

    echo "[client]" >> "$Mysql__config_file"
    echo "user = $Database__mysql_user" >> "$Mysql__config_file"
    echo "password = $Database__mysql_pass" >> "$Mysql__config_file"
    echo "host = $Database__mysql_host" >> "$Mysql__config_file"
}

#################################################
# Deletes the temporary database config file
#################################################
Mysql__delete_config() {
    # Deleting old mysql config file if it existed
    if [[ -e "$Mysql__config_file" ]]; then
        rm "$Mysql__config_file"
    fi
}

