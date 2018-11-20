.PHONY: logo deploy docs_build restore develop docs_deploy lint

# Deploy HomelabOS
deploy: logo get_roles
	ansible-playbook --extra-vars="@config.yml" -i inventory homelabos.yml

logo:
	cat homelaboslogo.txt

get_roles:
	sudo ansible-galaxy install toke.tor

# Initial configuration
config: logo
	ansible-playbook --extra-vars="@config.yml" -i setup_inventory setup.yml
	echo "========== Configuration completed! Now just run 'make' =========="

# Reset all local settings
config_reset: logo
	cp config.yml.blank config.yml

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo
	ansible-playbook --extra-vars="@config.yml" -i inventory -t deploy homelabos.yml

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo
	which mkdocs && mkdocs build || echo "Unable to build the documentation. Please install mkdocs."

# Update just the docs
docs_deploy: logo docs_build
	ansible-playbook -i inventory -t docs homelabos.yml

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo
	ansible-playbook -i inventory restore.yml

# Spin up a development stack
develop: logo get_roles
	vagrant plugin install vagrant-disksize
	vagrant up
	vagrant provision

# Execute against a test server
test: logo
	ansible-playbook -i test_hosts homelabos.yml

# Run linting scripts
lint: logo
	pip install yamllint
	find . -type f -name '*.yml*' | sed 's|\./||g' | egrep -v '(\.kitchen/|\[warning\]|\.molecule/)' | xargs yamllint -f parsable
