# Matomo

## Setup

During the setup wizard, your Database host should be `db` and the database name, user, and password, all `matomo`.

## Access

It is available via [https://matomo.{{ domain }}/](https://matomo.{{ domain }}/) or [http://matomo.{{ domain }}/](http://matomo.{{ domain }}/).

{% if enable_tor %}
It is also available via Tor at [http://matomo.{{ tor_domain }}/](http://matomo.{{ tor_domain }}/)
{% endif %}
