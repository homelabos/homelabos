# NextCloud

[NextCloud](https://nextcloud.com/) is your Dropbox / Google Calendar replacement.

## About

Nextcloud can be a beast to setup. Therefore, HomelabOS does as much as it can to provide intelligent defaults, and common configuration settings out of the box.

Specifically, HomelabOS configures Nextcloud in the following ways:
* Postgres as the default database server, mariadb as an alternative
* Redis for caching
* Nextcloud 21, served by Apache
* Docker is set to run the main Nextcloud container as the same Uid/Gid that mounts your NAS. (or your non-root server-user's UID/GID)
* 'App Store' Access is enabled
* Default Username is pulled from your config/vault yaml file
* Default Password is pulled from your config/vault yaml file
* Mounts/Volumes - these are all configured to persist across container restarts.
  - {{ volumes_root }}/nextcloud/apps - host accessible volume containing self-installed apps.
  - {{ volumes_root }}/nextcloud/config - host accessible volume containing configuration.
    - when necessary, users can directly edit the config.php file - for instance, to fix the login-loop bug with mobile apps.
  - {{ volumes_root }}/nextcloud/themes - host accessible volume containing custom theme files.
  - {{ volumes_root }}/nextcloud/webroot - host accessible volume containing the actuall nextcloud php files, and user-data root folders.
  - {{ storage_dir }}/ - mounted internally as /mnt/homelabos

## Configuration Notes

!!! Warning "Use https_only"
    After you enable Nextcloud, it is recommended to set force https_only on the Nextcloud service to true. However, if you're using the http provisioning system for LetsEncrypt, you'll need to wait to enable https_only until the cert has been generated.

!!! Note "Auto installation takes a few minutes"
    Once make has finished running, it will take a few minutes - depending on your servers' hardware capabilities - to finish setting up Nextcloud. HomelabOS pre-configures:
    * Database
    * Default User & Password - check your config and vault files for details on what these are set to.

## Post Installation Configuration

Nextcloud, as an application, is *designed* to silo users' data apart from one-another. (this is a good thing). However, this causes issues when you want to allow users to access a common data store - like a NAS. To facilitate this, HomelabOS mounts your hosts' {{storage_dir}} in the container as the /mnt/homelabos folder. Once you've installed and configured Nextcloud, you'll need to take the following steps to make your {{storage_dir}} available to users:

1. Launch settings, and select Apps.
2. Select 'disabled' apps
3. Click the enable button next to 'External Storage Support'
4. _*Logout*_ - Do not skip this step.
5. *Login* and navigate to Settings -> External Storage (*Under Administration*)
6. Add a new External Storage with the following configuration
  - Folder Name: HomelabOS
  - External Storage: Local
  - Authentication: None
  - Configuration: /mnt/homelabos
7. Click the check icon.
8. Profit!

After completing these steps, your Users will see a HomelabOS folder under files. More advanced users can probably re-map the default file locations for pictures etc. to be under the HomelabOS folder.

## Access

It is available at [https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/) or [http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nextcloud.subdomain + "." + tor_domain }}/](http://{{ nextcloud.subdomain + "." + tor_domain }}/)
{% endif %}
