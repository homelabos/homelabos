# Jellyfin

[Jellyfin](https://github.com/jellyfin/jellyfin) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://jellyfin.{{ domain }}/](https://jellyfin.{{ domain }}/) or [http://jellyfin.{{ domain }}/](http://jellyfin.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://jellyfin.{{ tor_domain }}/](http://jellyfin.{{ tor_domain }}/)
{% endif %}
