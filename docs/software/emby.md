# Emby

[Emby](https://emby.media/) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://emby.{{ domain }}/](https://emby.{{ domain }}/) or [http://emby.{{ domain }}/](http://emby.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://emby.{{ tor_domain }}/](http://emby.{{ tor_domain }}/)
{% endif %}
