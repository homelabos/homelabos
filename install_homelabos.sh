#!/bin/bash

VERSION=dev

# Install make
printf "\x1B[01;93m========== Updating system ==========\n\x1B[0m"
apt update
printf "\x1B[01;93m========== Install make and docker ==========\n\x1B[0m"
apt install -y make docker.io

# Download and extract HomelabOS
printf "\x1B[01;93m========== Download and extract HomelabOS ==========\n\x1B[0m"
[ -d HomelabOS-$VERSION/ ] || wget https://gitlab.com/NickBusey/HomelabOS/-/archive/$VERSION/HomelabOS-$VERSION.tar.gz
[ -d HomelabOS-$VERSION/ ] || tar -xvzf HomelabOS-$VERSION.tar.gz
[ -d HomelabOS-$VERSION/ ] || rm HomelabOS-$VERSION.tar.gz

printf "\x1B[01;93m========== Create install directory ==========\n\x1B[0m"
sudo mkdir -p /var/homelabos/data
sudo mv HomelabOS-$VERSION/* /var/homelabos/data/
cd /var/homelabos/data
sudo mkdir settings/
chown -R $(whoami) ./

# Setup IP configuration
@printf "\x1B[01;93m========== Configure networking ==========\n\x1B[0m"
export HOMELAB_IP=$(hostname -I | awk '{print $1}')
printf "homelab_ip: $HOMELAB_IP\nhomelab_ssh_user: $(whoami)" > settings/config.yml

printf "We have detected and set your homelab_ip to: $HOMELAB_IP\nIf this is incorrect, edit your /var/homelabos/data/settings/config.yml file to fix it.\n"
printf "\n\n\x1B[01;92m========== HomelabOS downloaded! ==========\n\x1B[0m"
printf "\n\x1B[01;93mYou can check the status of Organizr with `systemctl status homelabos` or `sudo docker ps`"
printf "\nTo enable more services, run 'cd /var/homelabos/data' then './set_setting.sh enable_SERVICENAME true'"
printf "\nwhere SERVICENAME is a service you would like to have."
printf "\n\nExample: './set_setting.sh enable_miniflux true'";
printf "\n\nOnce you have enabled all the services you would like, simply run 'make'.\n\n";
printf "\x1B[01;92m================== Done.  ==================\n\x1B[0m\n\n"
