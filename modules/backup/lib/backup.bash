#!/bin/bash

#################################################
# Backs up the entire database
#################################################
Backup__index() {
    tables=$(Database__get_tables);

    words=( $tables )
    if [ ${#words[@]} -gt 0 ]; then

        # Preparing backup directory
        timestamp=$(date +%s)
        backup_dir="./backups/$timestamp"
        mkdir "$backup_dir"
        mkdir "$backup_dir/tables"
        last_migration=$(Database__get_most_recent_migration)
        echo "$last_migration" > "$backup_dir/last_migration.txt"

        # Backing up each file
        for table in $tables
        do
            file="$backup_dir/tables/$table.sql"
            Database__backup_table "$table" "$file"
        done
    else
        Logger__alert "There are no tables to backup"
    fi
}

#################################################
# Restores an entire database
#
# @param $1: The timestamp of the backup.
# This is also the folder name in the backups 
# directory
#################################################
Backup__restore() {
    if [[ -z "$1" ]]; then
        Logger__error "backup:restore requires a second parameter for the timestamp of the backup."
    else
        echo "Backup__restore $1"
    fi
}

