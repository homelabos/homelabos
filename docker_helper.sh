#!/bin/sh

VERSION=$(cat VERSION)
SSH_KEY=${SSH_KEY:-"${HOME}/.ssh/id_rsa"}

if [ ! -f "$HOME/.homelabos_vault_pass" ]; then
    echo "Oops, I cannot find your vault password in $HOME/.homelabos_vault_pass"
    echo "This is unusual, but could be caused by the user being changed during setup."
    read -p "Press ctrl-c and create the file in the right place.  Then file a bug report."
fi

if [ -f "${SSH_KEY}" -a -f "${SSH_KEY}.pub" -a -f "$HOME/.homelabos_vault_pass" ]; then
    docker run --rm -it \
      -v ${SSH_KEY}:/root/.ssh/id_rsa \
      -v ${SSH_KEY}.pub:/root/.ssh/id_rsa.pub \
      -v $(pwd):/data \
      -v $HOME/.homelabos_vault_pass:/ansible_vault_pass \
      homelabos:${VERSION} "$@"
else
    echo "You have no SSH keys in your home directory: $HOME"
    echo "Please generate a set of keys using the command:"
    echo "   ssh-keygen -t rsa"
    echo "or copy your id_rsa and id_rsa.pub keys to $HOME/.ssh/"
    echo "Then retry the operation"
    read -p "Press ctrl-c and fix your ssh keys"
fi
