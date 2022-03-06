# Mashio

[Mashio](https://gitlab.com/NickBusey/mashio) is a home brewery management software.

## Access

It is available at [https://{% if mashio.domain %}{{ mashio.domain }}{% else %}{{ mashio.subdomain + "." + domain }}{% endif %}/](https://{% if mashio.domain %}{{ mashio.domain }}{% else %}{{ mashio.subdomain + "." + domain }}{% endif %}/) or [http://{% if mashio.domain %}{{ mashio.domain }}{% else %}{{ mashio.subdomain + "." + domain }}{% endif %}/](http://{% if mashio.domain %}{{ mashio.domain }}{% else %}{{ mashio.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ mashio.subdomain + "." + tor_domain }}/](http://{{ mashio.subdomain + "." + tor_domain }}/)
{% endif %}
