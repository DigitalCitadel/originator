#!/bin/bash

# Getting backups directory
Backup_folder="$Originator__config_directory/$Backup__backups_folder"

#################################################
# Backs up the entire database
#################################################
Backup__index() {
    tables=$(Database__get_tables);

    words=( $tables )
    if [ ${#words[@]} -gt 0 ]; then

        # Preparing backup directory
        timestamp=$(date +%s)
        backup_dir="$Backup_folder/$timestamp"
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

        # logging success
        Logger__success "Backup $timestamp has been created"
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
        table_dir="$Backup_folder/$1/tables"
        if [[ -d $table_dir ]]; then
            if [[ "$(ls $table_dir)" ]]; then
                for file in "$table_dir"/*; do
                        Database__file_execute $file
                done
                Logger__success "Backup $1 has successfully been restored"
            else
                Logger__error "There aren't any files to restore in that backup"
            fi
        else
            Logger__error "Invalid timestamp"
        fi
    fi
}

#################################################
# Displays all of the available backups with
# their associated last migration
#################################################
Backup__map() {
    # Checking for valid backup
    if [[ -d $Backup_folder ]] && [[ "$(ls $Backup_folder)" ]]; then
        # Disabling logger prefix
        Logger__has_prefix=0

        # Looping over backup files
        for backup in "$Backup_folder"/*; do
            if [[ -d $backup ]]; then
                backup_basename="$(basename $backup)"
                Logger__log "$backup_basename : $(cat $backup/last_migration.txt)"
            fi
        done
    else
        Logger__error "There are no backups to display"
    fi
}

