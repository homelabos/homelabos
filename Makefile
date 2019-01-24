.PHONY: logo deploy docs_build restore develop lint

# Deploy HomelabOS
deploy: logo
	@ansible-playbook --extra-vars="@config.yml" -i inventory homelabos.yml

logo:
	@cat homelaboslogo.txt

# Initial configuration
config: logo
# If config.yml does not exist, populate it with a 'blank'
# yml file so the first attempt at parsing it succeeds
	@[ -f config.yml ] || cp config.yml.blank config.yml
	@ansible-playbook --extra-vars="@config.yml" -i setup_inventory setup.yml
	@echo "========== Configuration completed! Now edit config.yml to turn on the services you want, then run 'make' =========="

# Reset all local settings
config_reset: logo
	@cp config.yml.blank config.yml
	@echo "========== Configuration reset! Now just run 'make config' =========="

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo
	@ansible-playbook --extra-vars="@config.yml" -i inventory -t deploy homelabos.yml
	@echo "========== Update completed! =========="

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo
	which mkdocs && mkdocs build || echo "Unable to build the documentation. Please install mkdocs."

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo
	ansible-playbook -i inventory restore.yml

# Spin up a development stack
develop: logo
	#vagrant plugin install vagrant-disksize
	vagrant up
	vagrant provision

# Execute against a test server
test: logo
	ansible-playbook -i test_hosts homelabos.yml

# Run linting scripts
lint: logo
	pip install yamllint
	find . -type f -name '*.yml' | sed 's|\./||g' | egrep -v '(\.kitchen/|\[warning\]|\.molecule/)' | xargs yamllint -c yamllint.conf -f parsable
