#!/bin/bash

# Loading the appropriate database driver
if [[ "$Database__driver" = 'mysql' ]]; then
    . "$Originator__module_directory"/lib/database_drivers/mysql.bash
fi

