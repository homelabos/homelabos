# Generate Terraform files
touch settings/config.yml
./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.terraform.yml

# Run terraform
# If we send multiple commands to the docker container (/bin/bash -c), we can "cd" into the "settings" directory
#  then run terraform... which will then place the .tfstate file in the "settings" directory for safe keeping (aka "backing up")
./docker_helper.sh /bin/bash -c "cd settings; terraform init && terraform apply"

# Get instance IP for next run
TERRAFORM_IP=$(./docker_helper.sh /bin/bash -c "cd settings; terraform show -json | jq -r .values.root_module.resources[0].values.ipv4_address")

echo "Successfully created a server at: ${TERRAFORM_IP}\n\nPlace this IP where you want it in your settings (either 'homelab_ip' or 'bastion.server_address'), then run 'make' to complete the setup."

