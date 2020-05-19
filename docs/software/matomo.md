# Matomo

## Setup

During the setup wizard, your database connection information should all be autopopulated. Just click `Next`.

## Access

It is available via [https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](https://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/) or [http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/](http://{% if matomo.domain %}{{ matomo.domain }}{% else %}{{ matomo.subdomain + "." + domain }}{% endif %}/).

{% if enable_tor %}
It is also available via Tor at [http://{{ matomo.subdomain + "." + tor_domain }}/](http://{{ matomo.subdomain + "." + tor_domain }}/)
{% endif %}
