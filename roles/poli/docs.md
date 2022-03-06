# Poli

[Poli](https://github.com/shzlw/poli) An easy-to-use BI server built for SQL lovers. Power data analysis in SQL and gain faster business insights.

## Access

It is available at [https://{% if poli.domain %}{{ poli.domain }}{% else %}{{ poli.subdomain + "." + domain }}{% endif %}/](https://{% if poli.domain %}{{ poli.domain }}{% else %}{{ poli.subdomain + "." + domain }}{% endif %}/) or [http://{% if poli.domain %}{{ poli.domain }}{% else %}{{ poli.subdomain + "." + domain }}{% endif %}/](http://{% if poli.domain %}{{ poli.domain }}{% else %}{{ poli.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ poli.subdomain + "." + tor_domain }}/](http://{{ poli.subdomain + "." + tor_domain }}/)
{% endif %}
