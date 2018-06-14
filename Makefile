.PHONY: deploy build restore

# Deploy HomelabOS
deploy:
	ansible-playbook -i hosts homelabos.yml 

# Update just HomelabOS Services (skipping slow initial setup steps)
update:
	ansible-playbook -i hosts -t deploy homelabos.yml 

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
build:
	mkdocs build

# Restore a server with the most recent backup. Assuming Backups were running.
restore:
	ansible-playbook -i hosts restore.yml

# Spin up a development stack
develop:
	vagrant destroy --force
	vagrant up