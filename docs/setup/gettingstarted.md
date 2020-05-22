# Getting Started

Once you are all setup and ready to go you should be able to load Organizr at [http://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/](http://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/).

If you see `{ domain }` in the link above, you are either viewing these docs on the hosted GitLab pages and not actually through HomelabOS, or something is configured incorrectly.

## Securing Services

If you want to add an extra layer of authentication to a service, all you have to do is set `servicename.auth` to true. If [Authelia](/docs/software/authelia/) is enabled, it will handle authentication. Otherwise, Traefik will use HTTP Basic Auth with `default_username` and `default_password` as the credentials.

## File locations

HomelabOS sets up `{{ volumes_root }}` on your server, which maps to `/var/homelabos` by default

## Using Organizr

You can click the `Settings` link, then `Edit Tabs` to be able to add links to all the various HomelabOS services.

In the very near future, HomelabOS will provision these tab links for you automatically.

The URLs for all the services can be found in their individual documentation section.

## HTTPS via LetsEncrypt

HomelabOS will use Traefik's built in LetsEncrypt integration to automatically generate SSL certificates for your various services. If initially some of the certificates don't appear valid, you have likely run into [LetsEncrypt rate limits](https://letsencrypt.org/docs/rate-limits/). Unfortunately the only fix we have for that right now is 'wait a week'.

## Homelab Commands

`[client]$ make` - Deploys HomelabOS to the server 

`[client]$ make config` - Creates the settings/config.yml file and populates it with basic information

`[client]$ make config_reset` - Resets all local settings

`[client]$ make git_sync` - Syncs user settings to a git repo

`[client]$ make list_services` - Lists all available services to make it easier to find ot what is available

`[client]$ make logo` - Displays the HomelabOS logo, and checks the version

`[client]$ make build` - Builds the HomelabOS deploy docker image

`[client]$ make remove_one <service>` - Removes the specified service e.g. `[client]$ make remove_one inventario`

`[client]$ make restart` - Restarts all enabled services

`[client]$ make restart_one <service>` - Restarts the specified service e.g. `[client]$ make restart_one inventario`

`[client]$ make reset_one <service>` - Resets the specified service's data e.g. `[client]$ make reset_one inventario`

`[client]$ make restore` - Restores a server with the most recent backup. Assuming Backups were running.

`[client]$ make set <setting> <value>` - Sets the setting to value, e.g. `[client]$ make set organizr.enable True`

`[client]$ make get <setting>` - Displays the current setting of value, e.g. `[client]$ make get organizr.enable`

`[client]$ make tag <tag>` - Runs just the items tagged with a specific tag e.g. `[client]$ make tag tinc`

`[client]$ make terraform` - Spin up cloud servers with Terraform [See documentation](https://homelabos.com/docs/setup/terraform/)

`[client]$ make terraform_destroy` - Destroy servers created by Terraform

`[client]$ make update` - Skips the initial setup and updates HomelabOS services

`[client]$ make update_one <service>` - Updates just one HomelabOS service e.g. `[client]$ make update_one inventario`

`[client]$ make uninstall` - Removes HomelabOS services

`[client]$ make decrypt` - Decrypts the settings/vault.yml file so you can edit it.

`[client]$ make stop` - Stops all enabled services

`[client]$ make stop_one <service>` - Stops the specified service e.g. `[client]$ make stop_one inventario`
