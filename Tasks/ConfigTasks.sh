#!/usr/bin/env bash

# Configuration Tasks

# Config - Updates the config file, and ensures the vault is encrypted.
Task::config(){
  : @desc "Creates or Updates the config file as necessary."

  Task::logo
  Task::build

  highlight "Creating or Updating config file"
  mkdir -p settings/passwords
  [ -f ~/.homelabos_vault_pass ] || Task::generate_ansible_pass
  [ -f settings/vault.yml ] || cp config.yml.blank settings/vault.yml
  [ -f settings/config.yml ] || cp config.yml.blank settings/config.yml

  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i config_inventory playbook.config.yml
  highlight "Encrypting Secrets in the Vault"
  Task::run_docker ansible-vault encrypt settings/vault.yml || true
  highlight "Configuration Complete"

}

# Resets the local settings
Task::config_reset() {
  : @desc "Resets the Configuration"
  Task::logo
  Task::build

  highlight "Reset Local Settings"
  echo "First we'll make a backup of your current settings in case you actually need them \n"
  mv settings settings.bak
  mkdir settings
  Task::config
}

# Set a configuration variable
Task::set(){
  : @desc "Set a configuration variable"
  : @param key "Configuration Key to set"
  : @param value "Value to set"

  Task::decrypt

  # Try to figure out where key is defined
  FILE=settings/config.yml
  SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
  if [ -z ${SETTING_VALUE} ]; then
      FILE=settings/vault.yml
      SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
      if [ -z ${SETTING_VALUE} ]; then
          echo "Key does not exist in config.yml nor vault.yml."
          # Re-encrypt vault
          make encrypt
          exit 1
      fi
  fi

  echo "Found value in file: $FILE"

  echo "Old setting value: " ${SETTING_VALUE}
  # Setting the new value
  sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq w -i "$FILE" "$1" "$2"
  NEW_SETTING_VALUE=$(sudo docker run -it --rm -v ${PWD}:/workdir mikefarah/yq yq r "$FILE" "$1" "$2")
  echo "New setting value: " ${NEW_SETTING_VALUE}

  Task::encrypt
}
