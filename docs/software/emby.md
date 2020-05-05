# Emby

[Emby](https://emby.media/) is a media server. Just point it at your NAS collections of Movies and TV and you're off to the races.

## Access

It is available at [https://{% if emby.domain %}{{ emby.domain }}{% else %}{{ emby.subdomain + "." + domain }}{% endif %}/](https://{% if emby.domain %}{{ emby.domain }}{% else %}{{ emby.subdomain + "." + domain }}{% endif %}/) or [http://{% if emby.domain %}{{ emby.domain }}{% else %}{{ emby.subdomain + "." + domain }}{% endif %}/](http://{% if emby.domain %}{{ emby.domain }}{% else %}{{ emby.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ emby.subdomain + "." + tor_domain }}/](http://{{ emby.subdomain + "." + tor_domain }}/)
{% endif %}
