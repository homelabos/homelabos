# Matomo

## Setup

The Matomo installation wizard is automated by the role on first run: the
database connection is pre-populated via the `MATOMO_DATABASE_*` environment
variables, and the super user and first website steps are completed over HTTP.
No manual setup is required.

This automation only runs once (guarded by a `.configured` marker in the
Matomo data directory). If you need to re-run it, remove
`{{ volumes_root }}/matomo/.configured` and re-deploy after wiping the database
volume.

The admin password is generated automatically (unless `matomo.admin_password`
is set) and stored in `settings/passwords/matomo_admin_password`.

You can customise the install via these settings (all optional):

- `matomo.admin_user` (default `admin`)
- `matomo.admin_password` — if unset, a strong password is generated
- `matomo.admin_email` (default `admin@example.com`)
- `matomo.site_name` (default `My Site`)
- `matomo.site_url` (defaults to your service URL)

## Access

It is available via [https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/) or [http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/).

{% if enable_tor %}
It is also available via Tor at [http://{{ matomo.subdomain + "." + tor_domain }}/](http://{{ matomo.subdomain + "." + tor_domain }}/)
{% endif %}
