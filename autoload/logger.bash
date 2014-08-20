#!/bin/bash

# Constant
LOGGER_error_color='\033[1;31m'
LOGGER_success_color='\033[0;32m'
LOGGER_no_color='\033[1;0m'
LOGGER_alert_color='\033[1;34m'

# Configurable
LOGGER__prefix='Originator'
LOGGER__has_prefix=1

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
    if [ $LOGGER__has_prefix -eq 1 ]; then
        echo "<< $LOGGER__prefix >>: $1"
    else
        echo $1
    fi

    # Disabling color (if param is passed)
    if [ ! -z "$2" ]; then
        echo -ne "$LOGGER_no_color"
    fi
}

Logger__log() {
    Logger_log "$1" "$LOGGER_no_color"
}

Logger__error() {
    Logger_log "$1" "$LOGGER_error_color"
}

Logger__success() {
    Logger_log "$1" "$LOGGER_success_color"
}

Logger__alert() {
    Logger_log "$1" "$LOGGER_alert_color"
}

Logger__prompt() {
    if [ $LOGGER__has_prefix -eq 1 ]; then
        echo -n "<< $LOGGER__prefix >>: $1"
    else
        echo -n $1
    fi
}

