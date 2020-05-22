#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  function sha256sum() { shasum -a 256 "$@" ; } && export -f sha256sum
fi
date +%s | sha256sum | base64 | head -c 32  > ~/.homelabos_vault_pass
