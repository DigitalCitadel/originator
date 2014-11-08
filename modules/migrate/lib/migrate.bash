#!/bin/bash

# Determining the migrate folder
Migrate_folder="$Originator__config_directory/$Migrate__migrations_folder"

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

        # Determing location of migration and revert files
        migrate="$Migrate_folder/migrate/$migration_name"_migrate.sql
        revert="$Migrate_folder/revert/$migration_name"_revert.sql

        # Creating migration files
        touch "$migrate"
        Logger__success "Migration $migration_name""_migrate.sql has been created"
        touch "$revert"
        Logger__success "Revert $migration_name""_revert.sql has been created"

        # Creating migration in the database
        Database__create_migration "$migration_name"
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
            Migrate_handle_single_revert "$id" "$name"

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
    revert_file="$Migrate_folder/revert/$2"_revert.sql
    Mysql__file_execute "$revert_file"

    # Updating the database that we haven't ran this
    Database__set_ran_last "$1" 0
    Database__set_active "$1" 0

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
            Migrate_handle_single_migration "$id" "$name"

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
    migration_file="$Migrate_folder/migrate/$2"_migrate.sql
    Mysql__file_execute "$migration_file"

    # Updating the database that we've ran this
    Database__set_ran_last "$1" 1
    Database__set_active "$1" 1

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
# Displays a visual map of the current state
# of the migrations
#################################################
Migrate__map() {
    migrations=$(Database__get_map_data)

    words=( $migrations )
    if [ ${#words[@]} -ne 0 ]; then
        # Disabling logger prefix
        Logger__has_prefix=0

        # Going through all migrations
        for column in $migrations
        do
            # name column
            if [ "$name" == "" ]; then
                name=$column
                continue
            fi

            # active column
            if [ "$active" == "" ]; then
               active=$column
            fi

            # Handling
            Migrate_handle_single_map "$name" "$active"

            # Clearing
            name=""
            active=""
        done

        # Enabling logger prefix
        Logger__has_prefix=1
    else
        Logger__alert "There are no migrations to display"
    fi
}


#################################################
# Allows the user to step X number of steps
# through the migration list.
#
# In the event that the user requests more steps
# then available, we will simply go to the edge
# and not handle it beyond that.
#
# @param $1: A number prefixed with a "+" or "-"
#   For example, to step forward two migrations
#   this would be +2.  In order to revert back
#   five migrations, this would be -5.
#
#################################################
Migrate__step() {
    if [ -z "$1" ]; then
        Logger__error "migrate:step requires a second parameter"
    else
        # Validating input
        if [[ "$1" =~ [+-][[:digit:]]+$ ]]; then
            # Splitting input
            action=${1:0:1}
            number=${1:1:${#1}-1}
            # If step down
            if [ "$action" = "-" ]; then
                Migrate_step_down "$number"
            # If step up
            elif [ "$action" = "+" ]; then
                Migrate_step_up "$number"
            fi
        # Invalid Input
        else
            Logger__error "Invalid Input.  Input must be in this format: [+-][[:digit:]]+$"
        fi
    fi
}

#################################################
# Reverts $1 number of migrations starting from
# most recently migrated.
#
# @param $1: The number of migrations to revert
#################################################
Migrate_step_down() {
    migrations=$(Database__get_step_down_migrations "$1")
    error="There were no migrations to revert"

    # Executing the migrations
    Migrate_handle_multiple_revert "$migrations" "$error"
}

#################################################
# Migrates $1 number of migrations starting from
# the earliest migration.
#
# @param $1: The number of migrations to migrate
#################################################
Migrate_step_up() {
    migrations=$(Database__get_step_up_migrations $1)
    error="There were no migrations to execute"

    # Executing the migrations
    Migrate_handle_multiple_migration "$migrations" "$error"
}

#################################################
# Displays a single migration of the map
#
# @param $1: The name of the migration
# @param $2: The active status of the migration
#################################################
Migrate_handle_single_map() {
    # If migration is active
    if [ "$2" -eq 1 ]; then
        Logger__alert "> $1"

    # Migration is not active
    else
        Logger__log "  $1"
    fi
}

#################################################
# Runs through all of the migration files and
# puts the ones that aren't being tracked in the
# database.
#################################################
Migrate__update() {
    migrations_folder="$Migrate_folder/migrate/"

    # If there are migrations in the directory
    if [[ "$(ls $migrations_folder)" ]]; then
        for file in "$migrations_folder"*.sql
        do
            # Getting the migration name
            file_basename=$(basename "$file")
            migration_name=$(echo "$file_basename" | sed 's/\_migrate.sql//')

            # Getting the result from the database
            migration=$(Database__get_migration_from_name "$migration_name")

            # Checking if it already exists
            words=( $migration )
            if [ ${#words[@]} -eq 0 ]
            then
                Database__create_migration $migration_name
                Logger__success "Migration $migration_name is now being watched"
            fi
        done
    fi
}

#################################################
# Ensures that the database is set up
#################################################
Migrate__ensure_setup() {
    exists=$(Database__table_exists)

    # Table doesn't exist, create it
    if [ "$exists" -eq 0 ]; then
        # Creating Table
        Database__create_migrations_table

        # Logging
        Logger__alert "Created table $(Database__migration_table)"
    fi
}

