cd settings
terraform apply
HOMELAB_IP=$(terraform show -json | jq '.values.root_module.resources[0].values.ipv4_address')
cd ..
ansible-playbook  --extra-vars="@settings/config.yml" --extra-vars "homelab_ssh_user=root homelab_ip=$HOMELAB_IP" -i config_inventory playbook.config.yml
