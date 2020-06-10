#!/usr/bin/env bash

# Main deployment task - used to deploy HLOS
Task::deploy(){
    : @desc "Main deployment task - used to deploy HLOS"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Deploying HomelabOS"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.homelabos.yml
}

# Restart All Enabled services
Task::restart(){
  : @desc "Restart all enabled services"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Stopping all services"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
  highlight "Services restarting"
}

# Restart the selected service
Task::restart_one(){
  : @desc "Restarts the specified service"
  : @param service "Service Name"

  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory playbook.restart.yml
}

# Stop All Enabled services
Task::stop(){
  : @desc "Restart all enabled services"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Stopping all services"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.stop.yml
  highlight "Services restarting"
}

# Stop the selected service
Task::stop_one(){
  : @desc "Restarts the specified service"
  : @param service "Service Name"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory playbook.stop.yml
}

# Removes One Service
Task::remove_one(){
  : @desc "Removes the specified service on the HomelabOS server"
  : @param service "Service Name"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Removing data for ${_service}"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory playbook.remove.yml
  highlight "Removal Complete"
}

# Resets a services' data files
Task::reset_one(){
  : @desc "Resets the specified service' files on the HomelabOS server"
  : @param service "Service Name"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Resetting ${_service}"
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory playbook.stop.yml
	Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory playbook.remove.yml
	highlight "Redeploying ${_service}"
	Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["'${_service}'"]}' -i inventory -t deploy playbook.homelabos.yml
	highlight "Done resetting ${_service}"
}
