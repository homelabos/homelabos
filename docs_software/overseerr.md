# overseerr

[overseerr](https://overseerr.dev) Overseerr is a request management and media discovery tool built to work with your existing Plex ecosystem.

## Access

It is available at [https://{% if overseerr.domain %}{{ overseerr.domain }}{% else %}{{ overseerr.subdomain + "." + domain }}{% endif %}/](https://{% if overseerr.domain %}{{ overseerr.domain }}{% else %}{{ overseerr.subdomain + "." + domain }}{% endif %}/) or [http://{% if overseerr.domain %}{{ overseerr.domain }}{% else %}{{ overseerr.subdomain + "." + domain }}{% endif %}/](http://{% if overseerr.domain %}{{ overseerr.domain }}{% else %}{{ overseerr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ overseerr.subdomain + "." + tor_domain }}/](http://{{ overseerr.subdomain + "." + tor_domain }}/)
{% endif %}
