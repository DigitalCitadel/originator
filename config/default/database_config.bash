#!/bin/bash

#################################################
# Database driver -- `postgres` or `mysql`
#################################################
Database__driver='mysql'

#################################################
# MySQL config
#################################################
Database__mysql_path='mysql'
Database__mysql_user='root'
Database__mysql_pass='root'
Database__mysql_database='originator_test'
Database__mysql_host='localhost'
Database__mysql_migration_table='originator_migrations'

#################################################
# PosgreSQL config
#################################################
Database__postgres_path='/Library/PostgreSQL/9.4/bin/psql'
Database__postgres_user='postgres'
# You must use a .pgpass file
Database__postgres_database='originator_test'
Database__postgres_host='localhost'
Database__postgres_migration_table='originator_migrations'

