#!/bin/bash

# MIGRATION v0.7
# Only decrypt if the vault is encrypted - which it is at upgrade, but not at first install.
if sudo egrep -q "$ANSIBLE_VAULT" settings/vault.yml; then
  make decrypt || true
fi

# Fresh install has unencrypted, but correct vault.
# Otherwise perform migration steps.
if sudo egrep -q "vault:|blank_on_purpose:" settings/vault.yml; then
  echo "Vault already migrated to v0.7 - Skipping"
else
  sudo sed -i -ne 's/^/  /' settings/vault.yml
  echo -e "vault:\n$(cat settings/vault.yml)" > settings/vault.yml
  echo -e "[38;5;208mMigrated vault to v0.7 - NOTE: You will be asked for your sudo and default password again. [0m"
fi
# ENDMIGRATION
