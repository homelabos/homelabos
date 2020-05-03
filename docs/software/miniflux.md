# Miniflux

[Miniflux](https://miniflux.app/) is a minimalist and opinionated feed reader.

## Access

The dashboard is available at [https://rss.{{ domain }}/](https://rss.{{ domain }}/) or [http://rss.{{ domain }}/](http://rss.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://rss.{{ tor_domain }}/](http://rss.{{ tor_domain }}/)
{% endif %}
