#!/usr/bin/env bash

# Updates all services on the HomelabOS server
Task::update() {
  : @desc "Updates all services on the HomelabOS Server"
  : @param config_dir="settings"
  #Task::logo
  #Task::build
  #Task::git_sync
  #Task::config

  highlight "Updating HomelabOS Services using $_config_dir"
  Task::run_docker ansible-playbook --extra-vars="@$_config_dir/config.yml" --extra-vars="@$_config_dir/vault.yml" -i inventory -t deploy playbook.homelabos.yml
  Task::run_docker ansible-playbook --extra-vars="@$_config_dir/config.yml" --extra-vars="@$_config_dir/vault.yml" -i inventory playbook.restart.yml
  highlight "Update Complete"
}

# Updates the specified service on the HomelabOS server
Task::update_one(){
  : @desc "Updates the specified service on the HomelabOS server"
  : @param service "Service Name"
  : @param config_dir="settings"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  Task::run_docker ansible-playbook --extra-vars='{"services":["'${_service}'"]}' --extra-vars="@$_config_dir/config.yml" --extra-vars="@$_config_dir/vault.yml" -i inventory -t deploy playbook.homelabos.yml
  Task::run_docker ansible-playbook --extra-vars='{"services":["'${_service}'"]}' --extra-vars="@$_config_dir/config.yml" --extra-vars="@$_config_dir/vault.yml" -i inventory playbook.restart.yml
}
