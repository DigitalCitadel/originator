#!/bin/bash

# Loading the appropriate database driver
if [[ "$Database__driver" = 'mysql' ]]; then
    . "lib/database_drivers/mysql.bash" 
fi

