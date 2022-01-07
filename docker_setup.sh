#!/bin/bash

# If the user is root, end the script.
if [ "$(id -u)" == "0" ]; then
    exit 0
fi

# If user is not root, check if the user has a group named "docker".
if [ $(id -Gn | grep -c "docker") -eq 0 ]; then
    printf "\033[92m========== This account is NOT in the docker group ==========\033[0m\n"
    # Ask the user if they want to add the user to the docker group.
    read -p "Do you want to add yourself to the docker group? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Add the user to the docker group.
        sudo usermod -aG docker $USER
    fi
    # Tell the user to log out and log back in for changes to take effect.
    printf "\033[92m========== You must log out and back in for changes to take effect ==========\033[0m\n"
    exit 1
fi