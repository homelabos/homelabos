# Piwigo

[Piwigo](https://piwigo.org/) is a home inventory managament system.

## Access

It is available at [https://{% if piwigo.domain %}{{ piwigo.domain }}{% else %}{{ piwigo.subdomain + "." + domain }}{% endif %}/](https://{% if piwigo.domain %}{{ piwigo.domain }}{% else %}{{ piwigo.subdomain + "." + domain }}{% endif %}/) or [http://{% if piwigo.domain %}{{ piwigo.domain }}{% else %}{{ piwigo.subdomain + "." + domain }}{% endif %}/](http://{% if piwigo.domain %}{{ piwigo.domain }}{% else %}{{ piwigo.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ piwigo.subdomain + "." + tor_domain }}/](http://{{ piwigo.subdomain + "." + tor_domain }}/)
{% endif %}
