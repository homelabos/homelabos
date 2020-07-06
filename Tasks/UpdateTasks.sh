#!/usr/bin/env bash

# Updates all services on the HomelabOS server
Task::update() {
  : @desc "Updates all services on the HomelabOS Server"
  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Updating HomelabOS Services"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
  highlight "Update Complete"
}

# Updates the specified service on the HomelabOS server
Task::update_one(){
  : @desc "Updates the specified service on the HomelabOS server"
  : @param service "Service Name"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  Task::run_docker ansible-playbook --extra-vars='{"services":["'${_service}'"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
  Task::run_docker ansible-playbook --extra-vars='{"services":["'${_service}'"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
}
