#!/bin/bash
echo "#####################################################################################################"
echo "## This script can be used both from a client machine, and on the server to which you want to deploy HLOS"
echo "## We expect the server to be Debian or Ubuntu based"
echo "##    (apt, not yum, dnf, emerge, pkg, packman, sqg, swupd)"
echo "##"
echo "## The script bootstraps the server, preparing it for setup and deployment of services."
echo "## Your client computer needs to have a few things installed, so make sure your current user has sudo access"
echo "## If not, login as root and install sudo, then add your user to the sudoers group.  Logout and login again."
echo "## You only have to do this step once."
echo "##"
echo "## You also need to have access to the server, and be able to use sudo there. Check this before continuing"
echo "## by ssh user@yourserver.org . You should get a shell on the server."
echo "##"
echo "## Once logged in on the server try 'sudo ls'.  If this is fine, you are good to go."
echo "## If sudo does not work, su to root and add your user to /etc/group -> sudo line."
echo "##"
echo "##"
echo "## Press ctrl-c if you do not have sudo access with your user. Otherwise press <enter> to continue"
read -n1

repeat()
{
  ## Example use:
  # if repeat "Found server_credentials file from earlier run."; then
  #   echo "Repeating"
  # else
  #   echo "Not repeating"
  # fi
  echo "$1"
  read -n1 -t 5 -p "Type 'r' to repeat step, <enter> or wait to continue: " ans
  echo
  if [ "$ans" = "r" ]; then
    echo "* Repeating step"
    return 0
  else
    return 1
  fi
}

if [ -f /.dockerenv ]; then
    echo "* Running inside Docker container";
fi

# If I am root, don't use sudo (this happens in a Docker container)
SUDO=sudo
if [ "$USER" = "root" ]; then
  SUDO=
fi


if [ -f server_credentials ]; then
  echo "* Found and reusing server_credentials file from earlier run."
  source server_credentials
else
  echo
  echo "* First a few questions, then we are off."
  echo "* Enter your server IP and credentials.  Then we can get your ssh keys on the server."
  read -p "Enter your server IP-address: " ip
  read -p "Enter your server username: " user
  read -s -p "Enter your server password: " pass
  echo
  echo "* NOTE: This data is saved in a file called 'server_credentials'.  Delete or change the file if you want to change credentials."
  echo "ip=$ip" > server_credentials
  echo "user=$user" >> server_credentials
  echo "pass=$pass" >> server_credentials
  chmod 600 server_credentials
fi
export SSHPASS=$pass

# Install ansible, sshpass to get started
if [ ! -f /.dockerenv ]; then
  # Only run this if not in a Docker container
  echo
  if [ ! -f "/usr/bin/python3" ] || [ ! -f "/usr/bin/sshpass" ] || [ ! -f "/usr/bin/wget" ]; then
    echo "* I need sshpass and Python 3 on this machine, you may be asked to enter your sudo credentials:"
    $SUDO apt update
    $SUDO apt install -qy sshpass python3 python3-pip wget
  fi
fi

if [ -z $user_can_login ] || repeat "* Repeat step to determine if user can login and sudo on server?"; then
  ## check the user can access the server with the given credentials
  echo "* Test the server user is setup correctly with password or key connection, and can sudo."
  echo "* You may have to type your server password followed by sudo password (usually the same) now."
  sshpass -e ssh -o "StrictHostKeyChecking no" -t $user@$ip sudo echo "Successful login and upgrade to sudo.  You can continue installation."
  read -p "Did this succeed? Press <enter> if it did, otherwise <ctrl-c> and investigate. Maybe a mistyped password?"
  echo "user_can_login=yes" >> server_credentials
else
  echo "* Already determined the user can login to the server."
fi

echo
if [ -z $server_has_python ] || repeat "* Repeat step setting up Python 3 link on server?"; then
  echo "* mitogen 0.2.9 needs /usr/bin/python to exist.  We check for it and create a link to /usr/bin/python3 if this is so."
  echo "* If this does not work, then comment out the lines in this script about mitogen in the ansible.cfg part."
  sshpass -e ssh -t $user@$ip 'echo "Forcing /usr/bin/python to be Python 3" && sudo rm -f /usr/bin/python && sudo ln -s /usr/bin/python3 /usr/bin/python'
  # The line above is aggressively fixing things.  The line below does not work if python is already linked to python2
  # In any case, once new next mitogen is released, this while section can be removed.
  #ssh -t $user@$ip '[ ! -f /usr/bin/python ] && [ -f /usr/bin/python3 ] && echo "/usr/bin/python not found - making symlink" && sudo ln -s /usr/bin/python3 /usr/bin/python'
  echo "server_has_python=yes" >> server_credentials
else
  echo "* Server is known to have /usr/bin/python. Mitogen will work now."
fi

if [ ! -f /.dockerenv ]; then
  # Only installing virtualenv and setting up symlinks if not in a Docker container
  if [ ! -f "ansible/bin/ansible" ]; then
    echo "* Installing ansible in a Python virtual environment.  This means you can delete it after bootstrapping the server"
    echo "* if you want, and no changes were made on your client PC."
    pip3 install virtualenv
    python3 -m virtualenv ansible --python=python3
    cd ansible
    source bin/activate
    pip3 install ansible docker-py mitogen
  else
    echo "* Activating existing ansible virtualenv"
    cd ansible
    source bin/activate
  fi
fi

if [ ! -f /.dockerenv ]; then
  # Link in needed stuff form upper dirs.
  if [ ! -f "playbook.homelabos_api.yml" ]; then
    ln -s ../../playbook.homelabos_api.yml
    ln -s ../../roles
  fi
else
  # Link in needed stuff form upper dirs.
  if [ ! -f "playbook.homelabos_api.yml" ]; then
    ln -s ../playbook.homelabos_api.yml
    ln -s ../roles
  fi
fi

if [ ! -f "$HOME/.homelabos_vault_pass" ]; then
  echo "* Create Ansible vault password in $HOME/.homelabos_vault_pass"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    function sha256sum() { shasum -a 256 "$@" ; } && export -f sha256sum
  fi
  date +%s | sha256sum | base64 | head -c 32  > $HOME/.homelabos_vault_pass
else
  echo "* Using Ansible vault password in $HOME/.homelabos_vault_pass"
fi

if [ -f "$HOME/.ssh/id_rsa" -a -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo "* Found your SSH key in $HOME/.ssh/{id_rsa, id_rsa.pub}"
else
    echo "* You have no SSH keys in your home directory: $HOME"
    echo "* If you think this is an error, please copy your key to $HOME/.ssh/id_rsa and id_rsa.pub"
    read -p "Press ctrl-c and fix your ssh keys, or <enter> to generate a new key."
    echo "* Generating a set of keys with no passphrase, and save the file in $HOME/.ssh/id_rsa"
    ssh-keygen -N "" -t rsa -f $HOME/.ssh/id_rsa
fi

######
## Generate hlos user password
################################
## TODO: DELETE THIS PART - we don't allow any password log in to the hlos user.
#if [ ! -f "$HOME/.homelabos_hlos_password" ]; then
#  echo "* Generating a password for the 'hlos' user. It is stored in $HOME/.homelabos_hlos_password"
#  echo "* Ignore the warning about ignoring null character - it is all okay."
#  hlospass=`shuf -zer -n32  {A..Z} {a..z} {0..9}`
#  salt=`shuf -zer -n16  {A..Z} {a..z} {0..9}`
#  playbookpass=`echo -e $hlospass|mkpasswd -s --method=SHA-512 -S $salt`
#  echo "$hlospass $playbookpass" > $HOME/.homelabos_hlos_password
#else
#  echo "* Using password stored in $HOME/.homelabos_hlos_password for the 'hlos' user"
#  hlospass=`cat $HOME/.homelabos_hlos_password|cut -d' ' -f1`
#  playbookpass=`cat $HOME/.homelabos_hlos_password|cut -d' ' -f2`
#fi

######
## Prepare SSH keys for Ansible
################################
# Create certificates folder and copy SSH public key
mkdir -p certificates
cp $HOME/.ssh/id_rsa.pub certificates

######
##  Prepare Ansible
#########################
# Get the python version installed in the virtualenv.  This varies from distro to distro.
py=$(ls lib)

generate_ansible_cfg()
{
cat <<EOF
[defaults]
host_key_checking=false
interpreter_python=/usr/bin/python3
#TODO: mitogen insists on using /usr/bin/python, which on some distros is _still_ python 2.7!
#TODO: 0.2.10 mitogen will fix this issue.  Don't enable before.
#strategy_plugins=$PWD/lib/$py/site-packages/ansible_mitogen/plugins/strategy
#strategy=mitogen_linear
EOF
}
echo "$(generate_ansible_cfg)" > ansible.cfg

# Secure the inventory, then put stuff in it.
# There are two: One for the original server user, used for creating the hlos user
# and the one to use with hlos user we create to deploy the server.
touch inventory_user
chmod 600 inventory_user

generate_inventory_user_file()
{
cat <<EOF
[remotenode]
$ip

[all:vars]
# ssh credentials:
ansible_user=$user
ansible_password=$pass
# sudo credentials:
ansible_become=true
ansible_become_pass="{{ ansible_password }}"
# variables for user creation:
user_name=hlos
#TODO: Remove user_pass="$playbookpass"
EOF
}
echo "$(generate_inventory_user_file)" > inventory_user

touch inventory
chmod 600 inventory

generate_inventory_hlos_file()
{
cat <<EOF
[remotenode]
$ip

[all:vars]
ansible_user=hlos
host_ip=$ip
docker_ansible_user={{ ansible_user }}
user_name="{{ ansible_user }}"
volumes_root="/home/{{ ansible_user }}"
EOF
}
echo "$(generate_inventory_hlos_file)" > inventory_hlos

echo
echo "* Trying to contact your server using the server credentials given"
result=$(ansible -m ping -i inventory_user remotenode|grep pong)
if [ -z result ]; then
  echo "* Ansible cannot contact the server.  Please check your inputs and try again."
  exit 1
else
  echo "* Ansible Ping/Pong succeeded."
fi

## From here the actual installation is happening.
###################################################
if [ -z $deploy_done ] || repeat "* Repeat server installation step?"; then
  echo "* Now creating hlos user account and switch to that"
  ansible-playbook  -i inventory_user --tags=create_user playbook.homelabos_api.yml

  echo "* Test the hlos user is setup correctly with passwordless connection."
  result=$(ssh hlos@$ip echo "All is okay at \$HOME"|grep okay)
  if [ -z result ]; then
    echo "* SSH connection using SSH keys did not work.  Please check your inputs and try again."
    exit 1
  else
    echo "* SSH connection using SSH keys succeeded."
  fi

  echo "* Trying to contact your server using the hlos user via ansible"
  result=$(ansible -m ping -i inventory_hlos remotenode|grep pong)
  if [ -z result ]; then
    echo "* Ansible cannot contact the server.  Please check your inputs and try again."
    exit 1
  else
    echo "* Ansible Ping/Pong succeeded."
  fi

  echo "* Now installing docker and initial HomelabOS containers on the server"
  ansible-playbook  -i inventory_hlos --tags=deploy_base playbook.homelabos_api.yml
  echo "deploy_done=yes" >> ../server_credentials
fi

echo "* Test the ansible-api service is running.  You should see a message coming back.  Pause for a few seconds to let the service start up."
sleep 10
wget -q -O - http://$ip:8765/
echo

echo "* Everything should be in working order now.  Please visit the HLOS Web service at http://$ip:8080 and continue to setup the system from there."
echo
echo "* You can run this script multiple times in case something did not go as expected. Also feel free to delete everything from this machine."
