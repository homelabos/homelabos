#!/bin/bash

# If the OS is MacOS, then nothing needs to be done.
if [ "$(uname)" == "Darwin" ]; then
    exit 0
fi

# If the user is root, then nothing needs to be done.
if [ "$(id -u)" = "0" ]; then
    exit 0
fi

# If the user is not in the docker group, then add them to the group.
if ! groups $USER | grep -q '\bdocker\b'; then
    printf "\033[92m========== This account is NOT in the docker group ==========\033[0m\n"
    # Ask the user if they want to add the user to the docker group.
    read -p "Do you want to add yourself to the docker group? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Add the user to the docker group.
        sudo usermod -aG docker $USER
        # Tell the user to log out and log back in for changes to take effect.
        printf "\033[92m========== You must log out and back in for changes to take effect ==========\033[0m\n"
        exit 1
    fi
fi