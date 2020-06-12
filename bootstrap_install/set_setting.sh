#!/bin/bash
# $1 = the setting to change
# $2 = the new value for the setting
#
# Workflow:
# 1 - search for setting in config.yml
# 2 - if found, change it using the yq container
# 4 - if not found, it must be in the vault or non-existing
# 4.1 - decrypt the vault
# 4.2 - search for the setting
# 4.3 - if found, change it using the yq container
# 4.4 - encrypt the vault


# Try to figure out where key is defined
FILE=settings/config.yml
SETTING_VALUE=$(docker run  --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
if [ -z "${SETTING_VALUE}" ]; then
    FILE=settings/vault.yml
    # Decrypt vault
    docker exec ansible-api_ansible-api_1 ansible-vault decrypt --vault-password-file /ansible_vault_pass /playbooks/settings/vault.yml
    SETTING_VALUE=$(docker run --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
    if [ -z "${SETTING_VALUE}" ]; then
        echo "Key does not exist in config.yml nor vault.yml."
        # Re-encrypt vault
        docker exec ansible-api_ansible-api_1 ansible-vault encrypt --vault-password-file /ansible_vault_pass /playbooks/settings/vault.yml
        # We failed to find the key anywhere
        exit 1
    fi
fi

# Setting the new value
docker run  --rm -v ${PWD}:/workdir mikefarah/yq yq w -i "$FILE" "$1" "$2"
NEW_SETTING_VALUE=$(docker run --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
echo "Changed ${FILE} - $1"
echo "From: ${SETTING_VALUE}"
echo "To  : ${NEW_SETTING_VALUE}"

if [ $FILE == "settings/vault.yml" ]; then
  # Re-encrypt vault
  docker exec ansible-api_ansible-api_1 ansible-vault encrypt --vault-password-file /ansible_vault_pass /playbooks/settings/vault.yml
fi
