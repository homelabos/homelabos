#!/usr/bin/env bash

# Spin up a cloud server with Terraform https://homelabos.com/docs/setup/terraform/
Task::terraform(){
  : @desc "Spin up a cloud server with Terraform"

  Task::logo
  Task::build
  Task::git_sync
  Task::config

  highlight "Deploying cloud server"
  # Generate Terraform files
  Task::run_docker ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.terraform.yml

  # Run terraform
  # If we send multiple commands to the docker container (/bin/bash -c), we can "cd" into the "settings" directory
  #  then run terraform... which will then place the .tfstate file in the "settings" directory for safe keeping (aka "backing up")
  Task::run_docker /bin/bash -c "cd settings; terraform init && terraform apply"

  # Get instance IP for next run
  TERRAFORM_IP=$(Task::run_docker /bin/bash -c "cd settings; terraform show -json | jq -r .values.root_module.resources[0].values.ipv4_address")

  echo "Successfully created a server at: ${TERRAFORM_IP}\n\nPlace this IP where you want it in your settings (either 'homelab_ip' or 'bastion.server_address'), then run 'make' to complete the setup."

  highlight "Done deploying cloud server!"
}

# Destroys servers created by terraform
Task::terraform_destroy(){
  : @desc "Destroys servers created by terraform"

  highlight "Destroying cloud servers"
  Task::run_docker /bin/bash -c "cd settings; terraform destroy"
  highlight "Cloud Servers destroyed"
}
