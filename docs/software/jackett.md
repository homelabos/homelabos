# Jackett

[Jackett](https://github.com/Jackett/Jackett) provides API Support for your favorite torrent trackers.

## Configuration

It is important to secure Jackett! Access the Jackett dashboard with the links below,
scroll down to the `Jackett Configuration` section, and set a value for `Admin Password`.
Hit `Set Password` and you should be good to go.

Set up some indexers in the interface, and now in [Sonarr](/software/sonarr.md) and
[Radarr](/software/radarr.md) you can setup the link to Jackett.

## Access

The dashboard is available at [https://jackett.{{ domain }}/](https://jackett.{{ domain }}/) or [http://jackett.{{ domain }}/](http://jackett.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://jackett.{{ tor_domain }}/](http://jackett.{{ tor_domain }}/)
{% endif %}
