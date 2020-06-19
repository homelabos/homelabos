.PHONY: logo decrypt build deploy docs_build restore develop lint docs_local count_services

VERSION := $(cat VERSION)
bold := $(shell tput bold)
end := $(shell tput sgr0)
purple := $(shell tput setaf 93)
byel := $(bold)$(shell tput setaf 11)
bgre := $(bold)$(shell tput setaf 10)
bora := $(bold)$(shell tput setaf 214)
uid := $$(id -u)
gid := $$(id -g)

# Deploy HomelabOS - `make`
deploy: logo build git_sync config
	@printf "$(byel)========== Deploying HomelabOS ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.homelabos.yml

# Initial configuration
config: logo build
# If config.yml does not exist, populate it with a 'blank'
# yml file so the first attempt at parsing it succeeds
	@printf "$(byel)========== Updating configuration files ==========\n$(end)"
	@mkdir -p settings/passwords
	@[ -f ~/.homelabos_vault_pass ] || ./generate_ansible_pass.sh
	@[ -f settings/vault.yml ] || cp config.yml.blank settings/vault.yml
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
# MIGRATION v0.7
	@./migrate_vault.sh
# ENDMIGRATION
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i config_inventory playbook.config.yml
	@printf "$(byel)========== Encrypting secrets ==========\n$(end)"
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml || true
	@sudo chmod 640 settings/vault.yml
	@sudo chown $(uid):$(gid) settings/vault.yml
	@printf "$(byel)========== Done with configuration ==========\n$(end)"

# Display the HomelabOS logo and MOTD
logo:
	@cat homelaboslogo.txt
	@chmod +x check_version.sh
	@$(eval VERSION=`cat VERSION`)
	@./check_version.sh
	@printf "MOTD:\n\n$(bgre)" && curl -m 2 https://gitlab.com/NickBusey/HomelabOS/raw/master/MOTD || printf "Could not get MOTD"
	@printf "\n\n$(end)"

# Build the HomelabOS docker images
build:
	@$(eval VERSION=`cat VERSION`)
	@printf "$(byel)========== Preparing HomelabOS docker image ==========\n$(end)"
# First build the docker images needed to deploy
	@sudo docker inspect --type=image homelabos:$(VERSION) > /dev/null && printf "$(byel)========== Docker image already built ==========\n$(end)" || sudo docker build . -t homelabos:$(VERSION)

# Attempt to sync user settings to a git repo
git_sync:
	@./git_sync.sh || true

# Reset all local settings
config_reset: logo build
	@printf "$(byel)========== Reset local settings ==========$(end)"
	@printf "\n - First we'll make a backup of your current settings in case you actually needed them.\n"
	mv settings settings.bak
	mkdir settings
	@printf "\n - Then we'll set up a blank config file.\n"
	cp config.yml.blank settings/config.yml
	@printf "\n$(byel)========== Configuration reset! Now just run 'make config' ==========$(end)"

# Update just HomelabOS Services (skipping slower initial setup steps)
update: logo build git_sync config
	@printf "$(byel)========== Update HomelabOS ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "$(byel)========== Update completed! ==========$(end)"

# Update just one HomelabOS service `make update_one inventario`
update_one: logo build git_sync config
	@printf "$(byel)========== Update $(filter-out $@,$(MAKECMDGOALS)) ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.homelabos.yml
	@printf "$(byel)========== Restart $(filter-out $@,$(MAKECMDGOALS)) ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "$(byel)========== Update completed! ==========$(end)"

# Remove HomelabOS services
uninstall: logo build
	@printf "$(byel)========== Uninstall HomelabOS completely ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t deploy playbook.remove.yml
	@printf "$(byel)========== Uninstall completed! ==========$(end)"

# Remove one service
remove_one: logo build git_sync config
	@printf "$(byel)========== Remove data for $(filter-out $@,$(MAKECMDGOALS)) ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "$(byel)========== Done removing $(filter-out $@,$(MAKECMDGOALS))! ==========$(end)"

# Reset a service's data files
reset_one: logo build git_sync config
	@printf "$(byel)========== Removing data for $(filter-out $@,$(MAKECMDGOALS)) ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.remove.yml
	@printf "$(byel)========== Redeploying $(filter-out $@,$(MAKECMDGOALS)) ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory -t deploy playbook.homelabos.yml
	@printf "$(byel)========== Done resetting $(filter-out $@,$(MAKECMDGOALS))! ==========$(end)"

# Run just items tagged with a specific tag `make tag tinc`
tag: logo build git_sync config
	@printf "$(byel)========== Running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))' ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory -t $(filter-out $@,$(MAKECMDGOALS)) playbook.homelabos.yml
	@printf "$(byel)========== Done running tasks tagged with '$(filter-out $@,$(MAKECMDGOALS))'! ==========$(end)"

# Restore a server with the most recent backup. Assuming Backups were running.
restore: logo build git_sync config
	@printf "$(byel)========== Restoring from backup ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory restore.yml
	@printf "$(byel)========== Done restoring from backup! ==========$(end)"

# Run linting scripts
lint: logo build
	@printf "$(bora)Lint: $(end)"
	@./docker_helper.sh ./lint.sh

# Restart all enabled services
restart: logo build git_sync config
	@printf "$(byel)========== Restarting all services ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.restart.yml
	@printf "$(byel)========== Done restarting all services! ==========$(end)"

# Restart one service
restart_one: logo build git_sync config
	@printf "$(byel)========== Restarting '$(filter-out $@,$(MAKECMDGOALS))' ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.restart.yml
	@printf "$(byel)========== Done restarting '$(filter-out $@,$(MAKECMDGOALS))'! ==========$(end)"

# Stop all enabled services
stop: logo build git_sync config
	@printf "$(byel)========== Restarting all services ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" -i inventory playbook.stop.yml
	@printf "$(byel)========== Done restarting all services! ==========$(end)"

# Stop one service
stop_one: logo build git_sync config
	@printf "$(byel)========== Restarting '$(filter-out $@,$(MAKECMDGOALS))' ==========$(end)"
	@./docker_helper.sh ansible-playbook --extra-vars="@settings/config.yml" --extra-vars="@settings/vault.yml" --extra-vars='{"services":["$(filter-out $@,$(MAKECMDGOALS))"]}' -i inventory playbook.stop.yml
	@printf "$(byel)========== Done restarting '$(filter-out $@,$(MAKECMDGOALS))'! ==========$(end)"

# Spin up cloud servers with Terraform https://homelabos.com/docs/setup/terraform/
terraform: logo build git_sync
	@printf "$(byel)========== Deploying cloud server! ==========\n$(end)"
	@[ -f settings/config.yml ] || cp config.yml.blank settings/config.yml
	@./terraform.sh
	@printf "$(byel)========== Done deploying cloud servers! Run 'make' ==========$(end)"

# Destroy servers created by Terraform
terraform_destroy: logo build git_sync
	@printf "$(byel)========== Destroying cloud services! ==========\n$(end)"
	@./docker_helper.sh /bin/bash -c "cd settings; terraform destroy"
	@printf "$(byel)========== Done destroying cloud services! ==========$(end)"

decrypt:
	@printf "$(byel)========== Decrypting Ansible Vault! ==========\n$(end)"
	@./docker_helper.sh ansible-vault decrypt settings/vault.yml
	@sudo chmod 640 settings/vault.yml
	@sudo chown $(uid):$(gid) settings/vault.yml
	@printf "$(byel)========== Vault decrypted! settings/vault.yml ==========\n$(end)"

encrypt:
	@printf "$(byel)========== Encrypting Ansible Vault! ==========\n$(end)"
	@./docker_helper.sh ansible-vault encrypt settings/vault.yml
	@sudo chmod 640 settings/vault.yml
	@sudo chown $(uid):$(gid) settings/vault.yml
	@printf "$(byel)========== Vault Encrypted! settings/vault.yml ==========\n$(end)"

set: logo
	@printf "$(byel)========== Setting '$(filter-out $@,$(MAKECMDGOALS))' ==========$(end)"
	@./set_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "$(byel)========== Done! ==========$(end)"

get: logo
	@printf "$(byel)========== Getting '$(filter-out $@,$(MAKECMDGOALS))' ==========$(end)"
	@./get_setting.sh $(filter-out $@,$(MAKECMDGOALS))
	@printf "$(byel)========== Done! ==========$(end)"

# Serve the HomelabOS website locally
web:
	cd website && hugo serve

# Spin up a development stack
develop: logo build config
	@printf "$(byel)========== Spinning up dev stack ==========$(end)"
	@[ -f settings/test_config.yml ] || cp settings/config.yml settings/test_config.yml
	@vagrant up --provision
	@printf "$(byel)========== Done spinning up dev stack! ==========$(end)"

# Serve the HomelabOS Documentation locally
docs_local:
	@docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
docs_build: logo build git_sync config
	@printf "$(byel)========== Building docs ==========$(end)"
	@which mkdocs && mkdocs build || printf 'Unable to build the documentation. Please install mkdocs.'
	@printf "$(byel)========== Done building docs ==========$(end)"

# Return the amount of services included in this version of HomelabOS
count_services:
# This lists each folder in roles/ on it's own line, then excludes anything with homelabos or 'docs' in it, which are HomelabOS things and not services. Then it counts the number of lines.
	@ls -l roles | grep -v -e "homelab" -e "docs" | wc -l

list_services:
# This lists all available services as they are registerd in the group_vars/all file.
	@awk '/^services:/{flag=1; next}  /^docs:/{flag=0} flag' group_vars/all|awk '{gsub(/\:/, ""); print}'


# Hacky fix to allow make to accept multiple arguments
%:
	@:
