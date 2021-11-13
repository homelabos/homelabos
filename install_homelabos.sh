#!/bin/bash

VERSION=v0.8.4
REPO=NickBusey

while getopts r:v: option
do
    case "${option}"
            in
        v) VERSION=${OPTARG} ;;
        r) REPO=${OPTARG} ;;
    esac
done

is_tested() {
	case "$(. /etc/os-release && echo "$ID")" in
	*ubuntu* ) true ;;
	* ) false;;
	esac
}

hlos_install() {
    printf "\x1B[01;93m========== Updating system ==========\n\x1B[0m"
    sudo apt update

    printf "\x1B[01;93m========== Install make and docker ==========\n\x1B[0m"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-get update
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt install -y make docker-ce docker-ce-cli docker-compose containerd.io

    printf "\x1B[01;93m========== Ensure keys exist ==========\n\x1B[0m"
    # Create .ssh/ if it doesn't exist
    [ -d ~/.ssh/ ] || mkdir ~/.ssh
    # Generate passwordless keys if they don't exist
    [ -f ~/.ssh/id_rsa ] || ssh-keygen -N "" -f ~/.ssh/id_rsa
    # Create an authorized_keys file if it doesn't exist
    [ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys
    # Add our key to it if it is not present
    KEY=$(cat ~/.ssh/id_rsa.pub)
    grep -Fxq "$KEY" ~/.ssh/authorized_keys || cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

    # Download and extract HomelabOS
    printf "\x1B[01;93m========== Download and extract HomelabOS ==========\n\x1B[0m"
    curl -OL https://gitlab.com/$REPO/HomelabOS/-/archive/$VERSION/HomelabOS-$VERSION.tar.gz
    tar -xvzf HomelabOS-$VERSION.tar.gz
    rm HomelabOS-$VERSION.tar.gz

    printf "\x1B[01;93m========== Create install directory ==========\n\x1B[0m"
    sudo mkdir -p /var/homelabos/install
    sudo mv HomelabOS-$VERSION/* /var/homelabos/install/
    rm -rf HomelabOS-$VERSION
    cd /var/homelabos/install
    USER=$(whoami)
    sudo chown -R $USER ./
    mkdir settings

    # Setup IP configuration
    printf "\x1B[01;93m========== Configure networking ==========\n\x1B[0m"
    export HOMELAB_IP=$(hostname -I | awk '{print $1}')
    printf "homelab_ip: $HOMELAB_IP\nhomelab_ssh_user: $(whoami)" > settings/config.yml

    printf "We have detected and set your homelab_ip to: $HOMELAB_IP\nIf this is incorrect, edit your /var/homelabos/install/settings/config.yml file to fix it.\n"
    printf "\n\n\x1B[01;92m========== HomelabOS downloaded! ==========\n\x1B[0m"
    make deploy
    printf "\n\x1B[01;93mYou can check the status of Organizr with \x1B[01;92m'systemctl status organizr'\x1B[01;93m or \x1B[01;92m'sudo docker ps'\x1B[01;93m"
    printf "\nTo enable more services, run \x1B[01;92m'cd /var/homelabos/install'\x1B[01;93m then \x1B[01;92m'make set servicename.enable true'\x1B[01;93m"
    printf "\nwhere servicename is a service you would like to have."
    printf "\n\nExample: \x1B[01;92m'make set miniflux.enable true'";
    printf "\n\n\x1B[01;93mOnce you have enabled all the services you would like, simply run \x1B[38;5;184m'make deploy'.\x1B[01;93m\n\n";
    printf "\x1B[01;92m================== Done.  ==================\n\x1B[0m\n\n"
}

#Check if distro is tested, warn if not.
if is_tested; then
echo
else
    printf "\n\033[0;31mUntested operating system detected! You may press Ctrl+C now to abort this script.\nInstallation will proceed in 10 seconds.\n\n"
    sleep 10
fi

# Actually do the install. Put in function and run at end to prevent parcial download and execution.
hlos_install
