#!/bin/bash

# Constant
Logger_error_color='\033[1;31m'
Logger_success_color='\033[0;32m'
Logger_no_color='\033[1;0m'
Logger_alert_color='\033[1;34m'

# Configurable
Logger__prefix='Originator'
Logger__has_prefix=1

#################################################
# Logs a message
#
# @param $1: The message to log
# @param $2: The color to log
#################################################
Logger_log() {
    # Setting color (if param is passed)
    if [ ! -z "$2" ]; then
        echo -ne "$2"
    fi

    # Logging
    if [ $Logger__has_prefix -eq 1 ]; then
        echo "<< $Logger__prefix >>: $1"
    else
        echo "$1"
    fi

    # Disabling color (if param is passed)
    if [ ! -z "$2" ]; then
        echo -ne "$Logger_no_color"
    fi
}

Logger__log() {
    Logger_log "$1" "$Logger_no_color"
}

Logger__error() {
    Logger_log "$1" "$Logger_error_color"
}

Logger__success() {
    Logger_log "$1" "$Logger_success_color"
}

Logger__alert() {
    Logger_log "$1" "$Logger_alert_color"
}

Logger__prompt() {
    if [ $Logger__has_prefix -eq 1 ]; then
        echo -n "<< $Logger__prefix >>: $1"
    else
        echo -n "$1"
    fi
}

