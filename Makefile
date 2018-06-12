.PHONY: deploy build restore

# Deploy HomelabOS
deploy:
	ansible-playbook -i hosts -t homelabos homelabos.yml 

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
build:
	mkdocs build

# Restore a server with the most recent backup. Assuming Backups were running.
restore:
	ansible-playbook -i hosts restore.yml
