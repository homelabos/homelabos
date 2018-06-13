.PHONY: deploy build restore

# Deploy HomelabOS
deploy:
	cat homelaboslogo.txt
	ansible-playbook -i hosts homelabos.yml 

# Initial setup
setup:
	cat homelaboslogo.txt
	ansible-playbook -i setup_hosts setup.yml

# Update just HomelabOS Services (skipping slow initial setup steps)
update:
	cat homelaboslogo.txt
	ansible-playbook -i hosts -t deploy homelabos.yml 

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
build:
	cat homelaboslogo.txt
	mkdocs build

# Restore a server with the most recent backup. Assuming Backups were running.
restore:
	cat homelaboslogo.txt
	ansible-playbook -i hosts restore.yml
