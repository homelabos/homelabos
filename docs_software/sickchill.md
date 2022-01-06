# SickChill

[SickChill](https://sickchill.github.io/) SickChill is an automatic Video Library Manager for TV Shows.

## Access

It is available at [https://{% if sickchill.domain %}{{ sickchill.domain }}{% else %}{{ sickchill.subdomain + "." + domain }}{% endif %}/](https://{% if sickchill.domain %}{{ sickchill.domain }}{% else %}{{ sickchill.subdomain + "." + domain }}{% endif %}/) or [http://{% if sickchill.domain %}{{ sickchill.domain }}{% else %}{{ sickchill.subdomain + "." + domain }}{% endif %}/](http://{% if sickchill.domain %}{{ sickchill.domain }}{% else %}{{ sickchill.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ sickchill.subdomain + "." + tor_domain }}/](http://{{ sickchill.subdomain + "." + tor_domain }}/)
{% endif %}
