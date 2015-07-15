#!/bin/bash

#################################################
# Backs up one table in the database
#
# @param $1: The table to backup
# @param $2: The file to write it to
#################################################
Database__backup_table() {
    pg_dump \
        --column-inserts \
        --data-only \
        --username "$Database__postgres_user" \
        --host "$Database__postgres_host" \
        --table="$1" \
        "$Database__postgres_database" > "$2"
}

#################################################
# Gets all tables except originators migration
# table
#################################################
Database__get_tables() {
    read -d '' sql <<____EOF
    SELECT table_name
    FROM information_schema.tables
    WHERE table_type = 'BASE TABLE'
        AND table_schema = 'public';
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Gets the most recent migration that has been
# ran via the migrate module.
#################################################
Database__get_most_recent_migration() {
    read -d '' sql <<____EOF
    SELECT name
    FROM $Database__postgres_migration_table
    WHERE active='t'
    ORDER BY name DESC
    LIMIT 1
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Restores a single file
#
# @param $1: The file to restore
#################################################
Database__restore_file() {
    command=$(cat "$1")
    Postgres__execute "$command"
}
