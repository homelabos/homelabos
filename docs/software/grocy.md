# Grocy

[Grocy](https://grocy.info) ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home

## Access

Default login is user admin with password admin, please change the password immediately (see user menu).

It is available at [https://{% if grocy.domain %}{{ grocy.domain }}{% else %}{{ grocy.subdomain + "." + domain }}{% endif %}/](https://{% if grocy.domain %}{{ grocy.domain }}{% else %}{{ grocy.subdomain + "." + domain }}{% endif %}/) or [http://{% if grocy.domain %}{{ grocy.domain }}{% else %}{{ grocy.subdomain + "." + domain }}{% endif %}/](http://{% if grocy.domain %}{{ grocy.domain }}{% else %}{{ grocy.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ grocy.subdomain + "." + tor_domain }}/](http://{{ grocy.subdomain + "." + tor_domain }}/)
{% endif %}
