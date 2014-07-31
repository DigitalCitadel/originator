#!/bin/bash

# Executes a database statement
#
# @param $1: the statement to be executed
database_execute() {
    mysql   --user="$MYSQL_USER" \
            --password="$MYSQL_PASS" \
            --database="$MYSQL_DATABASE" \
            --execute="$1"
}

