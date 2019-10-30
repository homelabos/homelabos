# Generate Terraform files
touch settings/config.yml
./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" -i config_inventory /data/playbook.terraform.yml
cd settings

# Run terraform
../docker_helper.sh terraform init
../docker_helper.sh terraform apply

# Get instance IP for next run
TERRAFORM_IP=$(../docker_helper.sh terraform show -json | ../docker_helper.sh jq '.values.root_module.resources[0].values.ipv4_address')
cd ..

echo "Successfully created a server at $TERRAFORM_IP!\n\nRun 'make' to complete the setup."