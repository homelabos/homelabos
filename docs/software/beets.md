# Beets

[Beets](https://beets.io) Beets is the media library management system for obsessive-compulsive music geeks.

## Access

It is available at [https://{% if beets.domain %}{{ beets.domain }}{% else %}{{ beets.subdomain + "." + domain }}{% endif %}/](https://{% if beets.domain %}{{ beets.domain }}{% else %}{{ beets.subdomain + "." + domain }}{% endif %}/) or [http://{% if beets.domain %}{{ beets.domain }}{% else %}{{ beets.subdomain + "." + domain }}{% endif %}/](http://{% if beets.domain %}{{ beets.domain }}{% else %}{{ beets.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ beets + "." + tor_domain }}/](http://{{ beets + "." + tor_domain }}/)
{% endif %}
