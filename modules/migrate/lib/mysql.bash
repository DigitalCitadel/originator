#!/bin/bash

#################################################
# Executes a sql file
#
# @param $1: the sql file to be executed
#################################################
Database__file_execute() {
    mysql   --user="$Database__mysql_user" \
            --password="$Database__mysql_pass" \
            --database="$Database__mysql_database" \
            < "$1"
}

#################################################
# Executes a database statement
#
# @param $1: the statement to be executed
#################################################
Database_execute() {
    mysql   --user="$Database__mysql_user" \
            --password="$Database__mysql_pass" \
            --database="$Database__mysql_database" \
            --execute="$1"
}

#################################################
# Executes a database statement and 
# gives the output
#
# @param $1: the statement to be executed
#################################################
Database_fetch() {
    mysql   --silent \
            --skip-column-names \
            --batch \
            --user="$Database__mysql_user" \
            --password="$Database__mysql_pass" \
            --database="$Database__mysql_database" \
            --execute="$1"
    echo "$out"
}

#################################################
# Check if a database table exists
#################################################
Database__table_exists() {
    var=$(Database_execute "SHOW TABLES LIKE '$Database__mysql_migration_table'")
    if [ "$var" = "" ]; then
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
    echo "$Database__mysql_migration_table"
}

#################################################
# Creates the table to track migrations
#################################################
Database__create_migrations_table() {
    read -d '' sql <<____EOF
    CREATE TABLE $Database__mysql_migration_table
    (
        id BIGINT NOT NULL AUTO_INCREMENT,
            PRIMARY KEY (id),
        name VARCHAR(64) NULL,
        ran_last BOOLEAN NULL,
        active BOOLEAN NULL
    )
    ENGINE=InnoDB;
____EOF

    Database_execute "${sql}"
}

#################################################
# Creates a migration
#
# @param $1: The name of the migration
#################################################
Database__create_migration() {
    read -d '' sql <<____EOF
    INSERT INTO $Database__mysql_migration_table
    VALUES (DEFAULT, "$1", FALSE, FALSE);
____EOF

    Database_execute "${sql}"
}

#################################################
# Sets all migrations ran_last to false
#################################################
Database__reset_ran_last() {
    read -d '' sql <<____EOF
        UPDATE $Database__mysql_migration_table
        SET ran_last=0;
____EOF

    Database_execute "${sql}"
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
        UPDATE $Database__mysql_migration_table
        SET ran_last=$2
        WHERE id=$1;
____EOF

    Database_execute "${sql}"
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
        UPDATE $Database__mysql_migration_table
        SET active=$2
        WHERE id=$1;
____EOF

    Database_execute "${sql}"
}

#################################################
# Get's all migrations that were ran last
#################################################
Database__get_last_ran() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__mysql_migration_table
    WHERE ran_last=1
    ORDER BY name ASC;
____EOF

    echo $(Database_fetch "${sql}")
}


#################################################
# Gets all names + active information
#################################################
Database__get_map_data() {
    read -d '' sql <<____EOF
    SELECT name, active
    FROM $Database__mysql_migration_table
    ORDER BY name ASC;
____EOF

    echo $(Database_fetch "${sql}")
}

#################################################
# Get's all outstanding migrations
#################################################
Database__get_outstanding_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__mysql_migration_table
    WHERE active=0
    ORDER BY name ASC;
____EOF

    echo $(Database_fetch "${sql}")
}

#################################################
# Gets migrations for the step_down function
#
# @param $1: The number of migrations to get
#################################################
Database__get_step_down_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__mysql_migration_table
    WHERE active=1
    ORDER BY name DESC
    LIMIT $1
____EOF

    echo $(Database_fetch "${sql}")
}

#################################################
# Gets migrations for the step_up function
#
# @param $1: The number of migrations to get
#################################################
Database__get_step_up_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__mysql_migration_table
    WHERE active=0
    ORDER BY name ASC
    LIMIT $1
____EOF

    echo $(Database_fetch "${sql}")
}

#################################################
# Gets all active migrations
#################################################
Database__get_active_migrations() {
    read -d '' sql <<____EOF
    SELECT id, name
    FROM $Database__mysql_migration_table
    WHERE active=1
    ORDER BY name ASC;
____EOF

    echo $(Database_fetch "${sql}")
}

#################################################
# Returns a migration from it's name
#
# @param $1: The name of the migration
#################################################
Database__get_migration_from_name() {
    read -d '' sql <<____EOF
    SELECT *
    FROM $Database__mysql_migration_table
    WHERE name="$1";
____EOF

    echo $(Database_fetch "${sql}")
}

