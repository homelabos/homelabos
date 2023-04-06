#!/bin/sh

VERSION=$(cat VERSION)
SSH_KEY=${SSH_KEY:-"${HOME}/.ssh/id_rsa"}

if [ -f "${SSH_KEY}" -a -f "${SSH_KEY}.pub" -a -f "$HOME/.homelabos_vault_pass" ]; then
    docker run --rm -it \
      -v ${SSH_KEY}:/root/.ssh/id_rsa:Z \
      -v ${SSH_KEY}.pub:/root/.ssh/id_rsa.pub:Z \
      -v $(pwd):/data:Z \
      -v $HOME/.homelabos_vault_pass:/ansible_vault_pass:Z \
      nickbusey/homelabos:${VERSION} "$@"
elif [ -f "${SSH_KEY}" -a -f "${SSH_KEY}.pub" ]; then
    docker run --rm -it \
      -v ${SSH_KEY}:/root/.ssh/id_rsa:Z \
      -v ${SSH_KEY}.pub:/root/.ssh/id_rsa.pub:Z \
      -v $(pwd):/data:Z \
      nickbusey/homelabos:${VERSION} "$@"
else
    echo "You have no SSH keys in your home directory: $HOME"
    echo "Please generate a set of keys using the command:"
    echo "   ssh-keygen -t rsa"
    echo "or copy your id_rsa and id_rsa.pub keys to $HOME/.ssh/"
    echo "Then retry the operation"
    read -p "Press ctrl-c and fix your ssh keys"
fi
