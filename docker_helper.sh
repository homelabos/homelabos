#!/bin/sh

VERSION=$(cat VERSION)

sudo docker run --rm -it \
  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
  -v $(pwd):/data \
  -v ~/.homelabos_vault_pass:/ansible_vault_pass \
  homelabos:${VERSION} "$@"
