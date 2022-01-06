# Jellyfin

[Jellyfin](https://github.com/jellyfin/jellyfin) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://{% if jellyfin.domain %}{{ jellyfin.domain }}{% else %}{{ jellyfin.subdomain + "." + domain }}{% endif %}/](https://{% if jellyfin.domain %}{{ jellyfin.domain }}{% else %}{{ jellyfin.subdomain + "." + domain }}{% endif %}/) or [http://{% if jellyfin.domain %}{{ jellyfin.domain }}{% else %}{{ jellyfin.subdomain + "." + domain }}{% endif %}/](http://{% if jellyfin.domain %}{{ jellyfin.domain }}{% else %}{{ jellyfin.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ jellyfin.subdomain + "." + tor_domain }}/](http://{{ jellyfin.subdomain + "." + tor_domain }}/)
{% endif %}
