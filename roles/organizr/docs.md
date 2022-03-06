# Organizr

[Organizr](https://organizr.app/) is a simple dashboard that allows to monitor and interact with many different services.

## Access

It is available at [https://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/](https://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/) or [http://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/](http://{% if organizr.domain %}{{ organizr.domain }}{% else %}{{ organizr.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ organizr.subdomain + "." + tor_domain }}/](http://{{ organizr.subdomain + "." + tor_domain }}/)
{% endif %}
