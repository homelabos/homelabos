# NextCloud

[NextCloud](https://nextcloud.com/) is your Dropbox / Google Calendar replacement.

## About

Nextcloud can be a beast to setup. Therefore, HomelabOS does as much as it can to provide intelligent defaults, and common configuration settings out of the box.

Specifically, HomelabOS configures Nextcloud in the following ways:
* Postgres as the default database server, mariadb as an alternative
* Redis for caching
* Nextcloud 22, served by Apache
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

!!! Warning "Nextcloud only supports upgrading to the next major version." 
    If the version of nextcloud.version field is not 21-apache, then iteratively update one major version at a time from the version currently running to 22-apache. This can be done by changing the version number explicitly in the nextcloud.version field of settings/config.yml to the next major version and running `make restart_one nextcloud`.

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

## Authentik SSO (OpenID Connect)

Nextcloud can authenticate against an Authentik IdP via OpenID Connect using the `user_oidc` app, alongside the normal local login (SSO coexists with local login — local accounts stay available).

To enable it:

1. **Configure the Authentik side (manual prerequisite, outside this role).** In the Authentik admin UI create an OIDC **Provider**:
   - Client Type: Confidential; record the Client ID and Client Secret.
   - Redirect URI / Origin: `https://<your-nextcloud-domain>/index.php/apps/user_oidc/login`
   - Add the provider to an **Application** with slug `nextcloud`.
2. **Enable and configure the role** in `settings/config.yml` under `nextcloud:`:
   ```yaml
   nextcloud:
     oidc_enabled: true
     oidc_client_id: <Authentik client id>
     oidc_client_secret: <Authentik client secret>
     oidc_discovery_uri: https://authentik.averneth.com/.well-known/openid-configuration
     # optional, defaults shown:
     # oidc_scope: openid email profile
     # oidc_uid_mapping: preferred_username
   ```
3. Deploy. The role installs/enables `user_oidc` and registers the provider using `occ`.

Notes:
- `oidc_uid_mapping: preferred_username` links the Authentik user to the existing Nextcloud account whose username matches the Authentik username — so an Authentik user named `nick` merges into the existing `nick` local account via soft auto-provisioning.
- After setup, the Nextcloud login page shows an SSO button alongside the local form, and you can still log in locally.

## Access

It is available at [https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](https://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/) or [http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/](http://{% if nextcloud.domain %}{{ nextcloud.domain }}{% else %}{{ nextcloud.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nextcloud.subdomain + "." + tor_domain }}/](http://{{ nextcloud.subdomain + "." + tor_domain }}/)
{% endif %}
