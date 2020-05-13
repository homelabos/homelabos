# Lidarr

[Lidarr](https://lidarr.audio/) Sonarr but for Music.

## Access

It is available at [https://{% if lidarr.domain %}{{ lidarr.domain }}{% else %}{{ lidarr.subdomain + "." + domain }}{% endif %}/](https://{% if lidarr.domain %}{{ lidarr.domain }}{% else %}{{ lidarr.subdomain + "." + domain }}{% endif %}/) or [http://{% if lidarr.domain %}{{ lidarr.domain }}{% else %}{{ lidarr.subdomain + "." + domain }}{% endif %}/](http://{% if lidarr.domain %}{{ lidarr.domain }}{% else %}{{ lidarr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ lidarr.subdomain + "." + tor_domain }}/](http://{{ lidarr.subdomain + "." + tor_domain }}/)
{% endif %}
