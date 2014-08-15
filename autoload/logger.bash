#!/bin/bash

LOGGER__error_color='\033[1;31m'
LOGGER__success_color='\033[0;32m'
LOGGER__no_color='\033[1;0m'
LOGGER__alert_color='\033[1;34m'
LOGGER__prefix='Originator'

Logger__log() {
    echo "<< $LOGGER__prefix >>: $1"
}

Logger__error() {
    echo -ne "$LOGGER__error_color"
    echo "<< $LOGGER__prefix >>: $1"
    echo -ne "$LOGGER__no_color"
}

Logger__success() {
    echo -ne "$LOGGER__success_color"
    echo "<< $LOGGER__prefix >>: $1"
    echo -ne "$LOGGER__no_color"
}

Logger__alert() {
    echo -ne "$LOGGER__alert_color"
    echo "<< $LOGGER__prefix >>: $1"
    echo -ne "$LOGGER__no_color"
}

Logger__prompt() {
    echo -n "<< $LOGGER__prefix >>: $1"
}

