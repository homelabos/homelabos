# Listmonk

[Listmonk](https://listmonk.app/) is a self-hosted newsletter and mailing list manager.

## Access

It is available at [https://{% if listmonk.domain %}{{ listmonk.domain }}{% else %}{{ listmonk.subdomain + "." + domain }}{% endif %}/](https://{% if listmonk.domain %}{{ listmonk.domain }}{% else %}{{ listmonk.subdomain + "." + domain }}{% endif %}/) or [http://{% if listmonk.domain %}{{ listmonk.domain }}{% else %}{{ listmonk.subdomain + "." + domain }}{% endif %}/](http://{% if listmonk.domain %}{{ listmonk.domain }}{% else %}{{ listmonk.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ listmonk.subdomain + "." + tor_domain }}/](http://{{ listmonk.subdomain + "." + tor_domain }}/)
{% endif %}

## Configuration

On first run, listmonk automatically sets up the database schema. The admin user is created on first visit to the web UI. Optionally, set `LISTMONK_ADMIN_USER` and `LISTMONK_ADMIN_PASSWORD` in `<your config section>` to auto-create the Super Admin on first start.

The database password is stored in `settings/passwords/listmonk_db_password`.

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
listmonk:
  https_only: True
  auth: True
```
