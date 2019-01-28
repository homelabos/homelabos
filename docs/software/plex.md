# Plex Media Server

[Plex](https://plex.tv/) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://plex.{{ domain }}/](https://plex.{{ domain }}/) or [http://plex.{{ domain }}/](http://plex.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://plex.{{ tor_domain }}/](http://plex.{{ tor_domain }}/)
{% endif %}
