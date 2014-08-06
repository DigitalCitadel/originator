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
        echo 0
    else
        echo 1
    fi
}

#################################################
# Creates the table to track migrations
#################################################
create_migrations_table() {
    read -d '' sql <<____EOF
    CREATE TABLE $1
    (
        id BIGINT NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (id),
        name VARCHAR(64) NULL,
        ran_last BOOLEAN NULL,
        active BOOLEAN NULL
    )
    ENGINE=InnoDB;
____EOF

    database_execute "${sql}"
}
