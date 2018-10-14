.PHONY: deploy docs_build restore develop provision docs_deploy

# Deploy HomelabOS
deploy:
	cat homelaboslogo.txt
	ansible-galaxy install toke.tor
	ansible-playbook -i hosts homelabos.yml 

# Initial setup
setup:
	cat homelaboslogo.txt
	make docs_build
	ansible-galaxy install toke.tor
	ansible-playbook -i setup_hosts setup.yml
	ansible-playbook -i hosts homelabos.yml

# Update just HomelabOS Services (skipping slow initial setup steps)
update:
	cat homelaboslogo.txt
	ansible-playbook -i hosts -t deploy homelabos.yml 

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build:
	cat homelaboslogo.txt
	mkdocs build

# Restore a server with the most recent backup. Assuming Backups were running.
restore:
	cat homelaboslogo.txt
	ansible-playbook -i hosts restore.yml

# Spin up a development stack
develop:
	cat homelaboslogo.txt
	vagrant plugin install vagrant-disksize
	vagrant destroy --force
	vagrant up

# Re-run just the Provision step (Ansible) against the Vagrant machine
provision:
	cat homelaboslogo.txt
	vagrant provision

# Update just the docs
docs_deploy:
	cat homelaboslogo.txt
	mkdocs build
	ansible-playbook -i hosts -t docs homelabos.yml 	

# Execute against a test server
test:
	cat homelaboslogo.txt
	ansible-playbook -i test_hosts homelabos.yml
