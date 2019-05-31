# Generate Terraform files
touch settings/config.yml
ansible-playbook --extra-vars="@settings/config.yml" -i config_inventory playbook.terraform.yml
cd settings

# Run terraform
terraform init
terraform apply

# Get instance IP for next run
HOMELAB_IP=$(terraform show -json | jq '.values.root_module.resources[0].values.ipv4_address')
cd ..

# Run `make config` to save the IP
ansible-playbook --extra-vars="@settings/config.yml" --extra-vars "homelab_ssh_user=root homelab_ip=$HOMELAB_IP" -i config_inventory playbook.config.yml

echo "Successfully created a server at $HOMELAB_IP!\n\nRun 'make' to complete the setup."