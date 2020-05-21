#!/bin/bash

# MIGRATION v0.7
make decrypt || true
if egrep -q "vault:|blank_on_purpose:" settings/vault.yml; then
  echo "Vault already migrated to v0.7 - Skipping"
else
  sed -i -ne 's/^/  /' settings/vault.yml
  echo -e "vault:\n$(cat settings/vault.yml)" > settings/vault.yml
  echo "[38;5;208mMigrated vault to v0.7 - NOTE: You will be asked for your sudo and default password again. [0m"
fi
# ENDMIGRATION
