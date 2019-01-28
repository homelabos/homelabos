# Synchthing

[Synchthing](https://syncthing.net/) is a powerful file synchronization tool. [NextCloud](nextcloud.md) can also do this, but Syncthing is nicer to work with servers and other people.

## Access

It is available at [https://sync.{{ domain }}/](https://sync.{{ domain }}/) or [http://sync.{{ domain }}/](http://sync.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://sync.{{ tor_domain }}/](http://sync.{{ tor_domain }}/)
{% endif %}
