# Deploy HomelabOS
deploy:
	ansible-playbook -i hosts -t homelabos homelabos.yml 

# Build the HomelabOs Documentation - Requires mkdocs with the Material Theme
build:
	mkdocs build
