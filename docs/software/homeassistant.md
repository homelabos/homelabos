# Home Assistant

[Home Assistant](https://www.home-assistant.io/) can automate just about any part of your home.

## Access

It is available at [https://{% if homeassistant.domain %}{{ homeassistant.domain }}{% else %}{{ homeassistant.subdomain + "." + domain }}{% endif %}/](https://{% if homeassistant.domain %}{{ homeassistant.domain }}{% else %}{{ homeassistant.subdomain + "." + domain }}{% endif %}/) or [http://{% if homeassistant.domain %}{{ homeassistant.domain }}{% else %}{{ homeassistant.subdomain + "." + domain }}{% endif %}/](http://{% if homeassistant.domain %}{{ homeassistant.domain }}{% else %}{{ homeassistant.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ homeassistant.subdomain + "." + tor_domain }}/](http://{{ homeassistant.subdomain + "." + tor_domain }}/)
{% endif %}
