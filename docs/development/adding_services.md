# How to Add Services to HomelabOS

## Create Role Folder

Copy an existing role folder like 'inventario' from the `roles/` folder,
then adapt the values as needed.

## Add Service to Documentation

### Create a Documentation Page

Each service should have it's own page within the `docs/software/` folder.
Use existing docs as a template.

### Link to Documentation Page

Update the `mkdocs.yml` file with a reference to the newly created doc file.

## Add Service to Inventory File

The service needs to be added to 3 places within
`group_vars/all`.

Finally under the `# Enabled List` section.
All services here should default to `False`.
Next under the `enabled_services:` section in alphabetical order. 
Finally under the `services:` section.

## Add Service to README

The service should be added under the list of `Available Software`.

## Add Service to `config.yml.j2`

In the config template `roles/homelabos_config/templates/config.yml.j2` the
service should be added in alphabetical order under the `# Services List` section.

# How to Debug a New Service

After a new service has been deployed, run `systemctl status SERVICE_NAME` to see
how it's doing.

If it's not running with an error like `(code=exited, status=1/FAILURE)`

Grab the value of the ExecStart line, and run it by hand. So if the ExecStart line looks like:
`ExecStart=/usr/bin/docker-compose -f /var/homelabos/zulip/docker-compose.zulip.yml -p zulip up`
then manually run the bit after the =, `/usr/bin/docker-compose -f /var/homelabos/zulip/docker-compose.zulip.yml -p zulip up` to see the error output directly.
