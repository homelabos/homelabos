# Matomo

## Setup

During the setup wizard, your Database host should be `db` and the database name and user should be `matomo`.

You can find the database password by running `cat settings/passwords/matomo_db_password` from within the HomelabOS root directory.

## Access

It is available via [https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/) or [http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/).

{% if enable_tor %}
It is also available via Tor at [http://{{ matomo.subdomain + "." + tor_domain }}/](http://{{ matomo.subdomain + "." + tor_domain }}/)
{% endif %}
