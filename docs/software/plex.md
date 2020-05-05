# Plex Media Server

[Plex](https://plex.tv/) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/](https://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/) or [http://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/](http://{% if plex.domain %}{{ plex.domain }}{% else %}{{ plex.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ plex.subdomain + "." + tor_domain }}/](http://{{ plex.subdomain + "." + tor_domain }}/)
{% endif %}
