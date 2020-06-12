#!/usr/bin/env bash

Task::v7migrations(){
  Task::vault_migration
}

Task::vault_migration(){
  if sudo egrep -q "ANSIBLE_VAULT.*AES256" settings/vault.yml; then
    echo "decrypting"
    Task::decrypt
  fi

  # Fresh install has unencrypted, but correct vault.
  # Otherwise perform migration steps.
  if sudo egrep -q "vault:|blank_on_purpose:" settings/vault.yml; then
    echo "Vault already migrated to v0.7 - Skipping"
  else
    sudo sed -i -ne 's/^/  /' settings/vault.yml
    echo -e "vault:\n$(cat settings/vault.yml)" > settings/vault.yml
    colorize yellow "Migrated vault to v0.7 - NOTE: You will be asked for your sudo and default password again."
  fi
}
