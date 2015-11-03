#!/bin/bash

#################################################
# Executes a database statement
#
# @param $1: The statement to be executed
#################################################
Postgres__execute() {
    Postgres_fetch_raw "$1" > /dev/null
}

#################################################
# Executes a database statement and
# gives the output
#
# This is a wrapper for Postgres_fetch_raw
# to enforce only space delimited output
#
# @param $1: The statement to be executed
#################################################
Postgres__fetch() {
    result=$(Postgres_fetch_raw "$1")
    stripped_result=${result//|/\ }
    echo $stripped_result
}

#################################################
# Executes a database statement and
# gives the output
#
# @param $1: The statement to be executed
#################################################
Postgres_fetch_raw() {
    "$Database__postgres_path" \
        --username "$Database__postgres_user" \
        --dbname "$Database__postgres_database" \
        --host "$Database__postgres_host" \
        --command "$1" \
        --no-align \
        --tuples-only
}
