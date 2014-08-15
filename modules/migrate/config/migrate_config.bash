#!/bin/bash

#################################################
# This calls migrate:update every time any
# command is ran.
#
# By default this is disabled, but you may want
# to consider enabling this if you're working
# in a team or between multiple environments. 
#
# In a production environment, this is something
# you would probably want to have disabled, and
# manage any updates manually.
#################################################
Migrate__always_update=0

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

