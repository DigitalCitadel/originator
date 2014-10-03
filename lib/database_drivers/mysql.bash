#!/bin/bash

#################################################
# Executes a sql file
#
# @param $1: the sql file to be executed
#################################################
Database__file_execute() {
    "$Database__mysql_path" \
        --user="$Database__mysql_user" \
        --password="$Database__mysql_pass" \
        --database="$Database__mysql_database" \
        < "$1"
}

#################################################
# Executes a database statement
#
# @param $1: the statement to be executed
#################################################
Database__execute() {
    "$Database__mysql_path" \
        --user="$Database__mysql_user" \
        --password="$Database__mysql_pass" \
        --database="$Database__mysql_database" \
        --execute="$1"
}

#################################################
# Executes a database statement and
# gives the output
#
# @param $1: the statement to be executed
#################################################
Database__fetch() {
    "$Database__mysql_path" \
        --silent \
        --skip-column-names \
        --batch \
        --user="$Database__mysql_user" \
        --password="$Database__mysql_pass" \
        --database="$Database__mysql_database" \
        --execute="$1"
    echo "$out"
}

