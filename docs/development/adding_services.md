# Before you begin

Before you begin, please familiarize yourself with the [contributing](contributing.md) document.

Also, make sure the project meets our standards for inclusion.

* Services should be in development for at least a year.
* Services should be actively maintained. (Last commit within 6 months.)

# How to Manually Add Services to HomelabOS

## Create Role Folder

Make the following folder structure
```
service_name
  tasks
  templates
```
In tasks add `main.yml` with the following content:
```
---

- name: Setup {{service_item}}
  include: includes/setup.yml

- name: Start {{service_item}}
  include: includes/start.yml

```
If the need additional setup steps, add them between the setup and start includes.

If the default setup and start steps don't work, remove the includes, copy/paste the contents of the included file, and modify as needed.

In templates/ add `docker-compose.servicename.yml.j2` and fill that out.
Look at other services as a reference.
### Use hardcoded volume paths

All mounted docker volumes should point to a folder named after the service that is using it, and located under `{{ volumes_root }}`.

## Add Service to Documentation

### Create a Documentation Page

Each service should have it's own page within the `docs_software/` folder.
Use existing docs as a template.

## Add Service to Inventory File

The service needs to be added within `group_vars/all`.

Place it in the `services:` section in alphabetical order. Also place it in the top level list.

## Add Service to docs/index.md

The service should be added under the list of `Available Software`.

## Add Service to `config.yml.j2`

In the config template `roles/homelabos_config/templates/config.yml.j2` the
service should be added in alphabetical order under the `# Services List` section.

## Add Service to CHANGELOG.md

Add at the top of the file, rather than under the previously newest release.

# How to Debug a New Service

After a new service has been deployed, run `systemctl status SERVICE_NAME` to see
how it's doing.

If it's not running with an error like `(code=exited, status=1/FAILURE)`

Grab the value of the ExecStart line, and run it by hand. So if the ExecStart line looks like:
`ExecStart=/usr/bin/docker-compose -p zulip up`
then manually change directory `cd {{ volumes_root }}/zulip` and run the bit after the =, `/usr/bin/docker-compose -p zulip up` to see the error output directly.
