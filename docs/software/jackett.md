# Jackett

[Jackett](https://github.com/Jackett/Jackett) provides API Support for your favorite torrent trackers.

## Configuration

It is important to secure Jackett! Access the Jackett dashboard with the links below,
scroll down to the `Jackett Configuration` section, and set a value for `Admin Password`.
Hit `Set Password` and you should be good to go.

Set up some indexers in the interface, and now in [Sonarr](/software/sonarr.md) and
[Radarr](/software/radarr.md) you can setup the link to Jackett.

## Access

The dashboard is available at [https://{% if jackett.domain %}{{ jackett.domain }}{% else %}{{ jackett.subdomain + "." + domain }}{% endif %}/](https://{% if jackett.domain %}{{ jackett.domain }}{% else %}{{ jackett.subdomain + "." + domain }}{% endif %}/) or [http://{% if jackett.domain %}{{ jackett.domain }}{% else %}{{ jackett.subdomain + "." + domain }}{% endif %}/](http://{% if jackett.domain %}{{ jackett.domain }}{% else %}{{ jackett.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ jackett.subdomain + "." + tor_domain }}/](http://{{ jackett.subdomain + "." + tor_domain }}/)
{% endif %}
