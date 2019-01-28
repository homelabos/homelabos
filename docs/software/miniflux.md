# Miniflux

[Miniflux](https://miniflux.app/) is a minimalist and opinionated feed reader.

## Configuration

Login to your server and run the following commands to configure Miniflux the first time.

Execute `docker exec -ti homelabos_miniflux_1 /usr/local/bin/miniflux -migrate`

Then `docker exec -ti homelabos_miniflux_1 /usr/local/bin/miniflux -create-admin`

## Access

The dashboard is available at [https://rss.{{ domain }}/](https://rss.{{ domain }}/) or [http://rss.{{ domain }}/](http://rss.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://rss.{{ tor_domain }}/](http://rss.{{ tor_domain }}/)
{% endif %}
