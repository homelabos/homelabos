# Synchthing

[Synchthing](https://syncthing.net/) is a powerful file synchronization tool. [NextCloud](nextcloud.md) can also do this, but Syncthing is nicer to work with servers and other people.

## Access

It is available at [https://{% if syncthing.domain %}{{ syncthing.domain }}{% else %}{{ syncthing.subdomain + "." + domain }}{% endif %}/](https://{% if syncthing.domain %}{{ syncthing.domain }}{% else %}{{ syncthing.subdomain + "." + domain }}{% endif %}/) or [http://{% if syncthing.domain %}{{ syncthing.domain }}{% else %}{{ syncthing.subdomain + "." + domain }}{% endif %}/](http://{% if syncthing.domain %}{{ syncthing.domain }}{% else %}{{ syncthing.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ syncthing.subdomain + "." + tor_domain }}/](http://{{ syncthing.subdomain + "." + tor_domain }}/)
{% endif %}
