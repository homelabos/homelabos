# Generate Terraform files
touch settings/config.yml
./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" -i config_inventory /data/playbook.terraform.yml
cd settings

# Run terraform
../docker_helper.sh terraform init
../docker_helper.sh terraform apply

# Get instance IP for next run
HOMELAB_IP=$(../docker_helper.sh terraform show -json | jq '.values.root_module.resources[0].values.ipv4_address')
cd ..

# Run `make config` to save the IP
./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars "homelab_ssh_user=root homelab_ip=$HOMELAB_IP" -i config_inventory /data/playbook.config.yml

echo "Successfully created a server at $HOMELAB_IP!\n\nRun 'make' to complete the setup."