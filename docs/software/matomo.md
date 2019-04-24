# Matomo

## Setup

During the setup wizard, your Database host should be `db` and the database name and user should be `matomo`.

You can find the database password by running `cat settings/passwords/matomo_db_password` from within the HomelabOS root directory.

## Access

It is available via [https://matomo.{{ domain }}/](https://matomo.{{ domain }}/) or [http://matomo.{{ domain }}/](http://matomo.{{ domain }}/).

{% if enable_tor %}
It is also available via Tor at [http://matomo.{{ tor_domain }}/](http://matomo.{{ tor_domain }}/)
{% endif %}
