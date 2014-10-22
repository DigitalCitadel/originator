#!/bin/bash

# Loading the appropriate database driver
if [[ "$Database__driver" = 'mysql' ]]; then
    . "$Originator__lib_directory"/lib/database_drivers/mysql.bash
fi

