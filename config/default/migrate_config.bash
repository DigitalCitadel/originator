#!/bin/bash

#################################################
# This is the location of the migrations folder
# in relation to the originator-files directory
#################################################
Migrate__migrations_folder="migrations"

#################################################
# This calls migrate:update every time any
# command is ran.
#
# In a production environment, this is something
# you could want to have disabled, and manage
# any updates manually.
#################################################
Migrate__always_update=1

#################################################
# Having this flag enabled will worn you each
# time you run a command, and will prompt
# you for your acknowledgement.
#
# This is disabled by default, but is highly
# recommended to enable if your application
# is actually in production.
#################################################
Migrate__app_in_production=1

