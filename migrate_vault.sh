# MIGRATION v0.7
#!/bin/bash

if cat settings/vault.yml | grep -q "vault:"
then
  echo "Vault already migrated to v0.7"
else
  make decrypt || true
  sed -i -ne 's/^/  /' settings/vault.yml
  echo "vault:\n$(cat settings/vault.yml)" > settings/vault.yml
  echo "Migrated vault to v0.7"
fi
# ENDMIGRATION