.PHONY: logo deploy docs_build restore develop lint

# Deploy HomelabOS
deploy: logo git_sync
	@ansible-playbook --extra-vars="@settings/config.yml" -i inventory playbook.homelabos.yml

logo:
	@cat homelaboslogo.txt
	@chmod +x check_version.sh
	@./check_version.sh
	@echo "MOTD:\x1B[01;93m" && curl https://gitlab.com/NickBusey/HomelabOS/raw/master/MOTD && echo "\n\x1B[0m"

git_sync:
	@mkdir settings > /dev/null 2>&1; cd settings && \
	 	git pull > /dev/null 2>&1 && \
		git add * > /dev/null 2>&1 && \
		git commit -a -m "Settings update" > /dev/null 2>&1 ; \
		git push > /dev/null 2>&1

# Initial configuration
config: logo git_sync
# If config.yml does not exist, populate it with a 'blank'
# yml file so the first attempt at parsing it succeeds
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@ansible-playbook --extra-vars="@settings/config.yml" -i config_inventory playbook.config.yml
	@echo "\x1B[01;93m========== Configuration completed! Now edit config.yml to turn on the services you want, then run 'make' ==========\n\x1B[0m"

# Reset all local settings
config_reset: logo
	@cp config.yml.blank config.yml
	@echo "\x1B[01;93m========== Configuration reset! Now just run 'make config' ==========\n\x1B[0m"

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo git_sync
	@ansible-playbook --extra-vars="@settings/config.yml" -i inventory -t deploy playbook.homelabos.yml
	@echo "\x1B[01;93m========== Update completed! ==========\n\x1B[0m"

# Update just one HomelabOS service
update_one: logo git_sync
	@ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@config.yml" -i inventory -t deploy playbook.homelabos.yml

%:
	@:

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo
	@which mkdocs && mkdocs build || echo "Unable to build the documentation. Please install mkdocs."

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo
	@ansible-playbook -i inventory restore.yml

# Spin up a development stack
develop: logo
	@#vagrant plugin install vagrant-disksize
	@vagrant up
	@vagrant provision

# Run linting scripts
lint: logo
	@pip install yamllint
	@find . -type f -name '*.yml' | sed 's|\./||g' | egrep -v '(\.kitchen/|\[warning\]|\.molecule/)' | xargs yamllint -c yamllint.conf -f parsable

# Restart all enabled services
restart: logo
	@ansible-playbook --extra-vars="@settings/config.yml" -i inventory playbook.restart.yml
