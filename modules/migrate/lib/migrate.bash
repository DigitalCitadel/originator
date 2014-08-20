#!/bin/bash

#################################################
# Creates a new migration
#
# @param $1: The name of the migration
#################################################
Migrate__make() {
    if [[ -z "$1" ]]; then
        Logger__error "migrate:make requires a second parameter for the name of the migration."
    else
        epoch_time=$(date +%s)
        migration_name="$epoch_time"_"$1"
        
        migrate=./migrations/migrate/"$migration_name"_migrate.sql
        revert=./migrations/revert/"$migration_name"_revert.sql

        # Creating migration files
        touch "$migrate"
        Logger__success "Migrate file located at $migrate"
        touch "$revert" 
        Logger__success "Revert file located at $revert"

        # Creating migration in the database
        Database__create_migration $migration_name
    fi
}

#################################################
# Rollback the last migration operation
#################################################
Migrate__rollback() {
    # Fetching Migrations
    migrations=$(Database__get_last_ran)
    error="The last set of migrations were already rolled back"

    # Rolling back the migrations
    Migrate_handle_multiple_revert "$migrations" "$error"
}

#################################################
# Performs a revert on multiple migrations
#
# @param $1: The migrations list
# @param $2: The error message to display if
#            there is nothing to migrate
#################################################
Migrate_handle_multiple_revert() {
    # Verifying that we have a migration to run
    words=( $1 )
    if [ ${#words[@]} -ne 0 ]; then

        # Going through all outstanding migrations
        for column in $1
        do
            # id column
            if [ "$id" == "" ]; then
                id=$column
                continue
            fi

            # name column
            if [ "$name" == "" ]; then
               name=$column
            fi

            # Handling
            Migrate_handle_single_revert $id $name

            # Clearing
            id=""
            name=""
        done
    else
        Logger__alert "$2"
    fi
}

#################################################
# Performs a revert on a single migration
#
# @param $1: The id of the migration
# @param $2: The name of the migration
#################################################
Migrate_handle_single_revert() {
    # Reverting the file
    revert_file=./migrations/revert/"$2"_revert.sql
    Database__file_execute $revert_file

    # Updating the database that we haven't ran this
    Database__set_ran_last $1 0
    Database__set_active $1 0

    # Logging our success
    Logger__success "Migration $2 has successfully been reverted"
}

#################################################
# Rollback all migrations
#################################################
Migrate__reset() {
    # Fetching Migrations
    migrations=$(Database__get_active_migrations)
    error="There were no migrations to revert"

    # Rolling back the migrations
    Migrate_handle_multiple_revert "$migrations" "$error"
}

#################################################
# Runs all outstanding migrations
#################################################
Migrate__index() {
    # Fetching Migrations
    migrations=$(Database__get_outstanding_migrations)
    error="There were no migrations to execute"

    # Executing the migrations
    Migrate_handle_multiple_migration "$migrations" "$error"
}

#################################################
# Performs a migration on multiple migrations
#
# @param $1: The migrations list
# @param $2: The error message to display if
#            there is nothing to migrate
#################################################
Migrate_handle_multiple_migration() {
    # Verifying that we have a migration to run
    words=( $1 )
    if [ ${#words[@]} -ne 0 ]; then

        # Setting all migrations ran_last to false
        Database__reset_ran_last

        # Going through all outstanding migrations
        for column in $1
        do
            # id column
            if [ "$id" == "" ]; then
                id=$column
                continue
            fi

            # name column
            if [ "$name" == "" ]; then
               name=$column
            fi

            # Handling
            Migrate_handle_single_migration $id $name

            # Clearing
            id=""
            name=""
        done
    else
        Logger__alert "$2"
    fi
}

#################################################
# Runs a single migration
#
# @param $1: The id of the migration
# @param $2: The name of the migration
#################################################
Migrate_handle_single_migration() {
    # Migrating the file
    migration_file=./migrations/migrate/"$2"_migrate.sql
    Database__file_execute $migration_file

    # Updating the database that we've ran this
    Database__set_ran_last $1 1
    Database__set_active $1 1

    # Logging our success
    Logger__success "Migration $2 has successfully been executed"
}

#################################################
# Rollback all migrations and run them all again
#################################################
Migrate__refresh() {
    Logger__alert "Refreshing all migrations"
    Migrate__reset
    Logger__alert "========="
    Migrate__index
    Logger__alert "All migrations have been refreshed"
}

#################################################
# Runs through all of the migration files and
# puts the ones that aren't being tracked in the
# database.
#################################################
Migrate__update() {
    migrations_files="migrations/migrate/*.sql"
    for file in $migrations_files
    do
        # Getting the migration name
        file_basename=$(basename $file)
        migration_name=$(echo $file_basename | sed 's/\_migrate.sql//')

        # Getting the result from the database
        migration=$(Database__get_migration_from_name $migration_name)

        # Checking if it already exists
        words=( $migration )
        if [ ${#words[@]} -eq 0 ]
        then
            Database__create_migration $migration_name
            Logger__success "Migration $migration_name is now being watched"
        fi
    done
}

#################################################
# Ensures that the database is set up
#################################################
Migrate__ensure_setup() {
    exists=$(Database__table_exists)

    # Table doesn't exist, create it
    if [ $exists -eq 0 ]; then
        # Creating Table
        Database__create_migrations_table

        # Logging
        Logger__alert "Created table $(Database__migration_table)"
    fi
}

