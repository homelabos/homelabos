#!/bin/bash

VERSION=dev

# Install make
sudo apt update
sudo apt install -y make docker.io

# Download and extract HomelabOS
[ -d HomelabOS-$VERSION/ ] || wget https://gitlab.com/NickBusey/HomelabOS/-/archive/$VERSION/HomelabOS-$VERSION.tar.gz
[ -d HomelabOS-$VERSION/ ] || tar -xvzf HomelabOS-$VERSION.tar.gz
[ -d HomelabOS-$VERSION/ ] || rm HomelabOS-$VERSION.tar.gz

cd HomelabOS-$VERSION
mkdir settings/

# Setup IP configuration
export HOMELAB_IP=$(sudo ./docker_helper.sh printf "$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')")
printf "homelab_ip: $HOMELAB_IP\nhomelab_ssh_user: $(whoami)" > settings/config.yml
printf "\n\n\x1B[01;92m========== HomelabOS downloaded! ==========\n\x1B[0m"
printf "\n\x1B[01;93mRun 'cd HomelabOS-$VERSION/' then './set_setting.sh enable_SERVICENAME true'"
printf "\nwhere SERVICENAME is a service you would like to have."
printf "\n\nExample: './set_setting.sh enable_miniflux true'";
printf "\n\nOnce you have enabled all the services you would like, simply run 'make'.\n\n";
printf "\x1B[01;92m================== Done.  ==================\n\x1B[0m\n\n"
