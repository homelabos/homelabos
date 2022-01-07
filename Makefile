.PHONY: logo decrypt build deploy docs_build restore develop lint docs_local count_services

VERSION := $(cat VERSION)

# Deploy HomelabOS - `make`
deploy: logo build git_sync config
	@printf "\033[92m========== Deploying HomelabOS ==========\033[0m\n"
	./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.homelabos.yml

# Initial configuration
config: logo build
# If config.yml does not exist, populate it with a 'blank'
# yml file so the first attempt at parsing it succeeds
	@printf "\033[92m========== Updating configuration files ==========\033[0m\n"
	@mkdir -p settings/passwords
	@[ -f ~/.homelabos_vault_pass ] || ./generate_ansible_pass.sh
	@[ -f settings/vault.yml ] || cp config.yml.blank settings/vault.yml
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i config_inventory playbook.config.yml
	@printf "\033[92m========== Encrypting secrets ==========\033[0m\n"
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml || true
	@printf "\033[92m========== Done with configuration ==========\033[0m\n"

# Display the HomelabOS logo and MOTD
logo:
	@cat homelaboslogo.txt
	@chmod +x check_version.sh
	@$(eval VERSION=`cat VERSION`)
	@./check_version.sh
	@printf "MOTD:\n\n\x1B[01;92m" && curl -m 2 https://gitlab.com/NickBusey/HomelabOS/raw/master/MOTD || printf "Couldn't get MOTD"
	@printf "\n\n\033[0m\n"

# Build the HomelabOS docker images
build:
	@$(eval VERSION=`cat VERSION`)
	@printf "\033[92m========== Preparing HomelabOS docker image ==========\033[0m\n"
# First build the docker images needed to deploy
	@chmod +x docker_setup.sh
	@./docker_setup.sh
	@sudo docker pull nickbusey/homelabos:$(VERSION) || true
	@sudo docker inspect --type=image nickbusey/homelabos:$(VERSION) > /dev/null && printf "\033[92m========== Docker image already built ==========\033[0m\n" || sudo docker build . -t nickbusey/homelabos:$(VERSION)

# Attempt to sync user settings to a git repo
git_sync:
	@./git_sync.sh || true

# Reset all local settings
config_reset: logo build
	@printf "\033[92m========== Reset local settings ==========\033[0m\n"
	@printf "\n - First we'll make a backup of your current settings in case you actually needed them.\n"
	mv settings settings.bak
	mkdir settings
	@printf "\n - Then we'll set up a blank config file.\n"
	cp config.yml.blank settings/config.yml
	@printf "\n\033[92m========== Configuration reset! Now just run 'make config' ==========\033[0m\n"

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo build git_sync config
	@printf "\033[92m========== Update HomelabOS ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\033[92m========== Update completed! ==========\033[0m\n"

# Update just one HomelabOS service `make update_one inventario`
update_one: logo build git_sync config
	@printf "\033[92m========== Update $(filter-out $@,$(MAKECMDGOALS)) ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@printf "\033[92m========== Restart $(filter-out $@,$(MAKECMDGOALS)) ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\033[92m========== Update completed! ==========\033[0m\n"

# Remove HomelabOS services
uninstall: logo build
	@printf "\033[92m========== Uninstall HomelabOS completely ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.remove.yml
	@printf "\033[92m========== Uninstall completed! ==========\033[0m\n"

# Remove one service
remove_one: logo build git_sync config
	@printf "\033[92m========== Remove data for $(filter-out $@,$(MAKECMDGOALS)) ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "\033[92m========== Done removing $(filter-out $@,$(MAKECMDGOALS))! ==========\033[0m\n"

# Reset a service's data files
reset_one: logo build git_sync config
	@printf "\033[92m========== Removing data for $(filter-out $@,$(MAKECMDGOALS)) ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "\033[92m========== Redeploying $(filter-out $@,$(MAKECMDGOALS)) ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory -t deploy playbook.homelabos.yml
	@printf "\033[92m========== Done resetting $(filter-out $@,$(MAKECMDGOALS))! ==========\033[0m\n"

# Run just items tagged with a specific tag `make tag tinc`
tag: logo build git_sync config
	@printf "\033[92m========== Running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))' ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t $(filter-out $@,$(MAKECMDGOALS)) playbook.homelabos.yml
	@printf "\033[92m========== Done running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))'! ==========\033[0m\n"

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo build git_sync config
	@printf "\033[92m========== Restoring from backup ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory restore.yml
	@printf "\033[92m========== Done restoring from backup! ==========\033[0m\n"

# Run linting scripts
lint: logo build
	@printf "[38;5;208mLint: [0m"
	@./docker_helper.sh ./lint.sh

# Restart all enabled services
restart: logo build git_sync config
	@printf "\033[92m========== Restarting all services ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "\033[92m========== Done restarting all services! ==========\033[0m\n"

# Restart one service
restart_one: logo build git_sync config
	@printf "\033[92m========== Restarting '$(filter-out $@,$(MAKECMDGOALS))' ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.restart.yml
	@printf "\033[92m========== Done restarting '$(filter-out $@,$(MAKECMDGOALS))'! ==========\033[0m\n"

# Stop all enabled services
stop: logo build git_sync config
	@printf "\033[92m========== Stopping all services ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.stop.yml
	@printf "\033[92m========== Done stopping all services! ==========\033[0m\n"

# Stop one service
stop_one: logo build git_sync config
	@printf "\033[92m========== Stopping '$(filter-out $@,$(MAKECMDGOALS))' ==========\033[0m\n"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@printf "\033[92m========== Done stopping '$(filter-out $@,$(MAKECMDGOALS))'! ==========\033[0m\n"

# Spin up cloud servers with Terraform https://homelabos.com/docs/setup/terraform/
terraform: logo build git_sync
	@printf "\033[92m========== Deploying cloud server! ==========\033[0m\n"
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@./terraform.sh
	@printf "\033[92m========== Done deploying cloud servers! Run 'make' ==========\033[0m\n"

# Destroy servers created by Terraform
terraform_destroy: logo build git_sync
	@printf "\033[92m========== Destroying cloud services! ==========\033[0m\n"
	@./docker_helper.sh /bin/bash -c "cd settings; terraform destroy"
	@printf "\033[92m========== Done destroying cloud services! ==========\033[0m\n"

decrypt:
	@printf "\033[92m========== Decrypting Ansible Vault! ==========\033[0m\n"
	@./docker_helper.sh ansible-vault decrypt settings/vault.yml
	@printf "\033[92m========== Vault decrypted! settings/vault.yml ==========\033[0m\n"

encrypt:
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml

set: logo
	@printf "\033[92m========== Setting '$(filter-out $@,$(MAKECMDGOALS))' ==========\033[0m\n"
	@./set_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "\033[92m========== Done! ==========\033[0m\n"

get: logo
	@printf "\033[92m========== Getting '$(filter-out $@,$(MAKECMDGOALS))' ==========\033[0m\n"
	@./get_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "\033[92m========== Done! ==========\033[0m\n"

# Serve the HomelabOS website locally
web:
	cd website && hugo serve

# Spin up a development stack
develop: logo build config
	@printf "\033[92m========== Spinning up dev stack ==========\033[0m\n"
	@[ -f settings/test_config.yml ] || cp settings/config.yml settings/test_config.yml
	@vagrant up --provision
	@printf "\033[92m========== Done spinning up dev stack! ==========\033[0m\n"

# Serve the HomelabOS Documentation locally
docs_local:
	@docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo build git_sync config
	@printf "\033[92m========== Building docs ==========\033[0m\n"
	@which mkdocs && mkdocs build || printf "Unable to build the documentation. Please install mkdocs."
	@printf "\033[92m========== Done building docs ==========\033[0m\n"

# Return the amount of services included in this version of HomelabOS
count_services:
# This lists each folder in roles/ on it's own line, then excludes anything with homelabos or 'docs' in it, which are HomelabOS things and not services. Then it counts the number of lines.
	@ls -l roles | grep -v -e "homelab" -e "docs" | wc -l

# Run sanity checks on services
test:
	@docker run -w /usr/src/app -v ${PWD}:/usr/src/app golang go run main.go

# Hacky fix to allow make to accept multiple arguments
%:
	@:

