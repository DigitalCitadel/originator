#!/bin/bash

#################################################
# Initializes an originator-files folder in the
# current directory
#################################################
Self__init() {
    # Checking if the current directory has been initialized
    if [[ -d "$Originator__config_directory" ]]; then
        Logger__error "The current directory is already initialized"
        exit
    fi

    # Initializing the directory
    mkdir "$Originator__config_directory"
    mkdir "$Originator__config_directory/backups"
    mkdir "$Originator__config_directory/migrations"
    mkdir "$Originator__config_directory/migrations/migrate"
    mkdir "$Originator__config_directory/migrations/revert"
    cp -R "$Originator__lib_directory/config" "$Originator__config_directory"

    # Success log
    Logger__success "The current directory has been initialized"
    Logger__alert "Don't forget to update the config files"
}

