#!/bin/sh

VERSION=$(cat VERSION)

if [ -f "$HOME/.ssh/id_rsa" -a -f "$HOME/.ssh/id_rsa.pub" ]; then
    sudo docker run --rm -it \
      -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
      -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
      -v $(pwd):/data \
      -v ~/.homelabos_vault_pass:/ansible_vault_pass \
      homelabos:${VERSION} "$@"
else
    echo "You have no SSH keys in your home directory: $HOME"
    echo "Please generate a set of keys using the command:"
    echo "   ssh-keygen -t rsa"
    echo "or copy your id_rsa and id_rsa.pub keys to $HOME/.ssh/"
    echo "Then retry the operation"
fi

