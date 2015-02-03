#!/bin/bash

#################################################
# Backs up one table in the database
#
# @param $1: The table to backup
# @param $2: The file to write it to
#################################################
Database__backup_table() {
    mysqldump \
            --defaults-extra-file="$Mysql__config_file" \
            --no-create-info \
            $Database__mysql_database \
            $1 > $2
}

#################################################
# Gets all tables except originators migration
# table
#################################################
Database__get_tables() {
    read -d '' sql <<____EOF
    SHOW tables
    FROM $Database__mysql_database
    WHERE Tables_in_$Database__mysql_database
        <> '$Database__mysql_migration_table';
____EOF

    echo $(Mysql__fetch "${sql}")
}


#################################################
# Gets the most recent migration that has been
# ran via the migrate module.
#################################################
Database__get_most_recent_migration() {
    read -d '' sql <<____EOF
    SELECT name
    FROM $Database__mysql_migration_table
    WHERE active=1
    ORDER BY name DESC
    LIMIT 1
____EOF

    echo $(Mysql__fetch "${sql}")
}

#################################################
# Restores a single file
#
# @param $1: The file to restore
#################################################
Database__restore_file() {
    command=$(cat "$1")
    Mysql__execute "$command"
}

