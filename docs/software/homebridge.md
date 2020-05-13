# HomeBridge

[HomeBridge](https://homebridge.io/) HomeKit support for the impatient

## Access

It is available at [https://{% if homebridge.domain %}{{ homebridge.domain }}{% else %}{{ homebridge.subdomain + "." + domain }}{% endif %}/](https://{% if homebridge.domain %}{{ homebridge.domain }}{% else %}{{ homebridge.subdomain + "." + domain }}{% endif %}/) or [http://{% if homebridge.domain %}{{ homebridge.domain }}{% else %}{{ homebridge.subdomain + "." + domain }}{% endif %}/](http://{% if homebridge.domain %}{{ homebridge.domain }}{% else %}{{ homebridge.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ homebridge.subdomain + "." + tor_domain }}/](http://{{ homebridge.subdomain + "." + tor_domain }}/)
{% endif %}
