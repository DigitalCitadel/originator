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
#################################################
database_table_exists() {
    var=$(database_execute "SHOW TABLES LIKE '$MYSQL_DATABASE'")
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
    CREATE TABLE $MYSQL_DATABASE
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


#################################################
# Creates a migration
#
# @param $1: The name of the migration
#################################################
create_migration() {
    read -d '' sql <<____EOF
    INSERT INTO $MYSQL_DATABASE
    VALUES (DEFAULT, "$1", FALSE, FALSE);
____EOF

    database_execute "${sql}"
}

