# Odoo

[Odoo](https://www.odoo.com/) is an open-source suite of business applications covering CRM, sales, inventory, accounting, project management, eCommerce, and more. It runs via Docker alongside a PostgreSQL database.

## Setup

After enabling and deploying Odoo, open it at:

```
https://{% if odoo.domain %}{{ odoo.domain }}{% else %}{{ odoo.subdomain + "." + domain }}{% endif %}/
```

On first deployment the initial database (`{{ odoo.db_name | default('odoo') }}`) is created automatically with a base install, and you can log straight in with the admin credentials below. The database manager master password is stored at `settings/passwords/odoo_admin_password`. To install additional applications afterwards, open the apps menu inside Odoo.

The setup can be customised in `settings/config.yml` under the `odoo:` block:

```
odoo:
  db_name: odoo
  admin_login: admin
  admin_email: admin@example.com
  lang: en_US
  country_code: US
```

## Database

Odoo stores its data in a bundled PostgreSQL instance at `{{ volumes_root }}/odoo/db-data` (mounted at `/var/lib/postgresql/data`). The database password is generated automatically and stored in `settings/passwords/odoo_db_password`.

Odoo application data persists at `{{ volumes_root }}/odoo/odoo-data` (mounted at `/var/lib/odoo`). Custom configuration files can be dropped into `{{ volumes_root }}/odoo/config` (mounted at `/etc/odoo`).

## Version

The Odoo and PostgreSQL versions can be adjusted in `settings/config.yml`:

```
odoo:
  version: 17
  db_version: 15
```

## Access

It is available at [https://{% if odoo.domain %}{{ odoo.domain }}{% else %}{{ odoo.subdomain + "." + domain }}{% endif %}/](https://{% if odoo.domain %}{{ odoo.domain }}{% else %}{{ odoo.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ odoo.subdomain + "." + tor_domain }}/](http://{{ odoo.subdomain + "." + tor_domain }}/)
{% endif %}
