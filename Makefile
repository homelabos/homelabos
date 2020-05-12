.PHONY: logo build deploy docs_build restore develop lint docs

VERSION := $(cat VERSION)

# Deploy HomelabOS - `make`
deploy: logo build git_sync config
	@printf "\x1B[01;93m========== Deploying HomelabOS ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.homelabos.yml

# Initial configuration
config: logo build
# If config.yml does not exist, populate it with a 'blank'
# yml file so the first attempt at parsing it succeeds
	@printf "\x1B[01;93m========== Updating configuration files ==========\n\x1B[0m"
	@mkdir -p settings
	@[ -f ~/.homelabos_vault_pass ] || date +%s | sha256sum | base64 | head -c 32  > ~/.homelabos_vault_pass
	@[ -f settings/vault.yml ] || cp config.yml.blank settings/vault.yml
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i config_inventory playbook.config.yml
	@printf "\x1B[01;93m========== Encrypting secrets ==========\n\x1B[0m"
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml settings/passwords/*
	@printf "\x1B[01;93m========== Done with configuration ==========\n\x1B[0m"

# Display the HomelabOS logo and MOTD
logo:
	@cat homelaboslogo.txt
	@chmod +x check_version.sh
	@$(eval VERSION=`cat VERSION`)
	@./check_version.sh
	@printf "MOTD:\x1B[01;92m" && curl -m 2 https://gitlab.com/NickBusey/HomelabOS/raw/master/MOTD || printf "Couldn't get MOTD"
	@printf "\n\x1B[0m"

# Build the HomelabOS docker images
build:
	@printf "\x1B[01;93m========== Preparing HomelabOS docker image ==========\n\x1B[0m"
# First build the docker images needed to deploy
	@sudo docker inspect --type=image homelabos:$(VERSION) > /dev/null && printf "\x1B[01;93m========== Docker image already built ==========\n\x1B[0m" || sudo docker build . -t homelabos:$(VERSION)

# Attempt to sync user settings to a git repo
git_sync:
	@./git_sync.sh || true

# Reset all local settings
config_reset: logo build
	@printf "\x1B[01;93m========== Reset local settings ==========\n\x1B[0m"
	@printf "\n - First we'll make a backup of your current settings in case you actually needed them.\n"
	mv settings settings.bak
	mkdir settings
	@printf "\n - Then we'll set up a blank config file.\n"
	cp config.yml.blank settings/config.yml
	@printf "\n\x1B[01;93m========== Configuration reset! Now just run 'make config' ==========\n\x1B[0m"

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo build git_sync config
	@printf "\x1B[01;93m========== Update HomelabOS ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\x1B[01;93m========== Update completed! ==========\n\x1B[0m"

# Update just one HomelabOS service `make update_one inventario`
update_one: logo build git_sync config
	@printf "\x1B[01;93m========== Update $(filter-out $@,$(MAKECMDGOALS)) ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@printf "\x1B[01;93m========== Restart $(filter-out $@,$(MAKECMDGOALS)) ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\x1B[01;93m========== Update completed! ==========\n\x1B[0m"

# Remove HomelabOS services
uninstall: logo build
	@printf "\x1B[01;93m========== Uninstall HomelabOS completely ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.remove.yml
	@printf "\x1B[01;93m========== Uninstall completed! ==========\n\x1B[0m"

# Remove one service
remove_one: logo build git_sync config
	@printf "\x1B[01;93m========== Remove data for $(filter-out $@,$(MAKECMDGOALS)) ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "\x1B[01;93m========== Done removing $(filter-out $@,$(MAKECMDGOALS))! ==========\n\x1B[0m"

# Reset a service's data files
reset_one: logo build git_sync config
	@printf "\x1B[01;93m========== Removing data for $(filter-out $@,$(MAKECMDGOALS)) ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "\x1B[01;93m========== Redeploying $(filter-out $@,$(MAKECMDGOALS)) ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory -t deploy playbook.homelabos.yml
	@printf "\x1B[01;93m========== Done resetting $(filter-out $@,$(MAKECMDGOALS))! ==========\n\x1B[0m"

# Run just items tagged with a specific tag `make tag tinc`
tag: logo build git_sync config
	@printf "\x1B[01;93m========== Running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))' ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t $(filter-out $@,$(MAKECMDGOALS)) playbook.homelabos.yml
	@printf "\x1B[01;93m========== Done running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))'! ==========\n\x1B[0m"

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo build git_sync config
	@printf "\x1B[01;93m========== Restoring from backup ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory restore.yml
	@printf "\x1B[01;93m========== Done restoring from backup! ==========\n\x1B[0m"

# Run linting scripts
lint: logo build
	@printf "[38;5;208mLint: [0m"
	@./docker_helper.sh ./lint.sh

# Restart all enabled services
restart: logo build git_sync config
	@printf "\x1B[01;93m========== Restarting all services ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\x1B[01;93m========== Done restarting all services! ==========\n\x1B[0m"

# Restart one service
restart_one: logo build git_sync config
	@printf "\x1B[01;93m========== Restarting '$(filter-out $@,$(MAKECMDGOALS))' ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.restart.yml
	@printf "\x1B[01;93m========== Done restarting '$(filter-out $@,$(MAKECMDGOALS))'! ==========\n\x1B[0m"

# Stop all enabled services
stop: logo build git_sync config
	@printf "\x1B[01;93m========== Restarting all services ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.stop.yml
	@printf "\x1B[01;93m========== Done restarting all services! ==========\n\x1B[0m"

# Stop one service
stop_one: logo build git_sync config
	@printf "\x1B[01;93m========== Restarting '$(filter-out $@,$(MAKECMDGOALS))' ==========\n\x1B[0m"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@printf "\x1B[01;93m========== Done restarting '$(filter-out $@,$(MAKECMDGOALS))'! ==========\n\x1B[0m"

# Spin up cloud servers with Terraform https://homelabos.com/docs/setup/terraform/
terraform: logo build git_sync
	@printf "\x1B[01;93m========== Deploying cloud server! ==========\n\x1B[0m"
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@./terraform.sh
	@printf "\x1B[01;93m========== Done deploying cloud servers! Run 'make' ==========\n\x1B[0m"

# Destroy servers created by Terraform
terraform_destroy: logo build git_sync
	@printf "\x1B[01;93m========== Destroying cloud services! ==========\n\x1B[0m"
	@cd settings && ../docker_helper.sh terraform destroy
	@printf "\x1B[01;93m========== Done destroying cloud services! ==========\n\x1B[0m"

decrypt: logo build
	@printf "\x1B[01;93m========== Decrypting Ansible Vault! ==========\n\x1B[0m"
	@./docker_helper.sh ansible-vault decrypt settings/vault.yml settings/passwords/*
	@printf "\x1B[01;93m========== Vault decrypted! settings/vault.yml ==========\n\x1B[0m"

encrypt:
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml settings/passwords/*

set: logo
	@printf "\x1B[01;93m========== Setting '$(filter-out $@,$(MAKECMDGOALS))' ==========\n\x1B[0m"
	@./set_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "\x1B[01;93m========== Done! ==========\n\x1B[0m"

get: logo
	@printf "\x1B[01;93m========== Getting '$(filter-out $@,$(MAKECMDGOALS))' ==========\n\x1B[0m"
	@./get_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "\x1B[01;93m========== Done! ==========\n\x1B[0m"

# Serve the HomelabOS website locally
web:
	cd website && hugo serve

# Spin up a development stack
develop: logo build config
	@printf "\x1B[01;93m========== Spinning up dev stack ==========\n\x1B[0m"
	@[ -f settings/test_config.yml ] || cp settings/config.yml settings/test_config.yml
	@vagrant up --provision
	@printf "\x1B[01;93m========== Done spinning up dev stack! ==========\n\x1B[0m"

# Serve the HomelabOS Documentation locally
docs_local:
	@docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo build git_sync config
	@printf "\x1B[01;93m========== Building docs ==========\n\x1B[0m"
	@which mkdocs && mkdocs build || printf "Unable to build the documentation. Please install mkdocs."
	@printf "\x1B[01;93m========== Done building docs ==========\n\x1B[0m"

# Hacky fix to allow make to accept multiple arguments
%:
	@:
