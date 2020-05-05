# Firefly III

[Firefly III](https://firefly-iii.org/) is a money management app.

## Access

It is available at [https://{% if firefly-iii.domain %}{{ firefly-iii.domain }}{% else %}{{ firefly-iii.subdomain + "." + domain }}{% endif %}/](https://{% if firefly-iii.domain %}{{ firefly-iii.domain }}{% else %}{{ firefly-iii.subdomain + "." + domain }}{% endif %}/) or [http://{% if firefly-iii.domain %}{{ firefly-iii.domain }}{% else %}{{ firefly-iii.subdomain + "." + domain }}{% endif %}/](http://{% if firefly-iii.domain %}{{ firefly-iii.domain }}{% else %}{{ firefly-iii.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ firefly-iii.subdomain + "." + tor_domain }}/](http://{{ firefly-iii.subdomain + "." + tor_domain }}/)
{% endif %}
