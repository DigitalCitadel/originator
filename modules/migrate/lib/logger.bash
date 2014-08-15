#!/bin/bash

ERROR_COLOR='\033[1;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[1;0m'
ALERT_COLOR='\033[1;34m'
APP_NAME='Originator'

log() {
    echo $1
}

log_error() {
    echo -ne "$ERROR_COLOR"
    echo "<< $APP_NAME >>: $1"
    echo -ne "$NO_COLOR"
}

log_success() {
    echo -ne "$SUCCESS_COLOR"
    echo "<< $APP_NAME >>: $1"
    echo -ne "$NO_COLOR"
}

log_alert() {
    echo -ne "$ALERT_COLOR"
    echo "<< $APP_NAME >>: $1"
    echo -ne "$NO_COLOR"
}
