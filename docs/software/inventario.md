# Inventario

[Inventario](https://gitlab.com/NickBusey/inventario) is a home inventory managament system.

## Access

It is available at [https://{% if inventario.domain %}{{ inventario.domain }}{% else %}{{ inventario.subdomain + "." + domain }}{% endif %}/](https://{% if inventario.domain %}{{ inventario.domain }}{% else %}{{ inventario.subdomain + "." + domain }}{% endif %}/) or [http://{% if inventario.domain %}{{ inventario.domain }}{% else %}{{ inventario.subdomain + "." + domain }}{% endif %}/](http://{% if inventario.domain %}{{ inventario.domain }}{% else %}{{ inventario.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ inventario.subdomain + "." + tor_domain }}/](http://{{ inventario.subdomain + "." + tor_domain }}/)
{% endif %}
