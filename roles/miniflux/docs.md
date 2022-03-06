# Miniflux

[Miniflux](https://miniflux.app/) is a minimalist and opinionated feed reader.

## Access

The dashboard is available at [https://{% if miniflux.domain %}{{ miniflux.domain }}{% else %}{{ miniflux.subdomain + "." + domain }}{% endif %}/](https://{% if miniflux.domain %}{{ miniflux.domain }}{% else %}{{ miniflux.subdomain + "." + domain }}{% endif %}/) or [http://{% if miniflux.domain %}{{ miniflux.domain }}{% else %}{{ miniflux.subdomain + "." + domain }}{% endif %}/](http://{% if miniflux.domain %}{{ miniflux.domain }}{% else %}{{ miniflux.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ miniflux.subdomain + "." + tor_domain }}/](http://{{ miniflux.subdomain + "." + tor_domain }}/)
{% endif %}
