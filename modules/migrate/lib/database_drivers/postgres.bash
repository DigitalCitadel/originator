#!/bin/bash

#################################################
# Check if a database table exists
#################################################
Database__table_exists() {
    read -d '' sql <<____EOF
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
        AND table_name = '$Database__postgres_migration_table';
____EOF

    tables=$(Postgres__fetch "${sql}")
    if [ "$tables" = "" ]; then
        echo 0
    else
        echo 1
    fi
}

#################################################
# Returns the database table we're using for
# migrations.
#################################################
Database__migration_table() {
    echo "$Database__postgres_migration_table"
}

#################################################
# Creates the table to track migrations
#################################################
Database__create_migrations_table() {
    primary_key="$Database__postgres_migration_table"_pk
    read -d '' sql <<____EOF
    CREATE TABLE $Database__postgres_migration_table (
        id BIGSERIAL,
        name VARCHAR(255) NULL,
        ran_last BOOLEAN NULL,
        active BOOLEAN NULL,
        CONSTRAINT $primary_key PRIMARY KEY (id)
    );
____EOF

    Postgres__execute "${sql}"
}

#################################################
# Creates a migration
#
# @param $1: The name of the migration
#################################################
Database__create_migration() {
    read -d '' sql <<____EOF
    INSERT INTO $Database__postgres_migration_table
    VALUES (DEFAULT, '$1', FALSE, FALSE);
____EOF

    Postgres__execute "${sql}"
}

#################################################
# Sets all migrations ran_last to false
#################################################
Database__reset_ran_last() {
    read -d '' sql <<____EOF
        UPDATE $Database__postgres_migration_table
        SET ran_last=FALSE;
____EOF

    Postgres__execute "${sql}"
}

#################################################
# Sets the migration with the id=$1
# ran_last to $2
#
# @param $1: The id of the migration
# @param $2: What to set ran_last to
#################################################
Database__set_ran_last() {
    read -d '' sql <<____EOF
        UPDATE $Database__postgres_migration_table
        SET ran_last='$2'
        WHERE id=$1;
____EOF

    Postgres__execute "${sql}"
}

#################################################
# Sets the migration with the id=$1
# active to $2
#
# @param $1: The id of the migration
# @param $2: What to set active to
#################################################
Database__set_active() {
    read -d '' sql <<____EOF
        UPDATE $Database__postgres_migration_table
        SET active='$2'
        WHERE id=$1;
____EOF

    Postgres__execute "${sql}"
}

#################################################
# Gets all migrations that were ran last
#################################################
Database__get_last_ran() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__postgres_migration_table
    WHERE ran_last='1'
    ORDER BY name DESC;
____EOF

    echo $(Postgres__fetch "${sql}")
}


#################################################
# Gets all names + active information
#################################################
Database__get_map_data() {
    read -d '' sql <<____EOF
    SELECT name, active
    FROM $Database__postgres_migration_table
    ORDER BY name ASC;
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Gets all outstanding migrations
#################################################
Database__get_outstanding_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__postgres_migration_table
    WHERE active='0'
    ORDER BY name ASC;
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Gets migrations for the step_down function
#
# @param $1: The number of migrations to get
#################################################
Database__get_step_down_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__postgres_migration_table
    WHERE active='1'
    ORDER BY name DESC
    LIMIT $1;
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Gets migrations for the step_up function
#
# @param $1: The number of migrations to get
#################################################
Database__get_step_up_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__postgres_migration_table
    WHERE active='0'
    ORDER BY name ASC
    LIMIT $1;
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Gets all active migrations
#################################################
Database__get_active_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__postgres_migration_table
    WHERE active='1'
    ORDER BY name DESC;
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Returns a migration from it's name
#
# @param $1: The name of the migration
#################################################
Database__get_migration_from_name() {
    read -d '' sql <<____EOF
    SELECT *
    FROM $Database__postgres_migration_table
    WHERE name='$1';
____EOF

    echo $(Postgres__fetch "${sql}")
}

#################################################
# Executes the contents of a file on the db
#
# @param $1: The file to execute
#################################################
Database__file_execute() {
    command=$(cat "$1")
    Postgres__execute "$command"
}

