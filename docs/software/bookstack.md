# bookstack

[Bookstack](https://www.bookstackapp.com/) Simple & Free Wiki Software

## Access

It is available at [https://{% if bookstack.domain %}{{ bookstack.domain }}{% else %}{{ bookstack.subdomain + "." + domain }}{% endif %}/](https://{% if bookstack.domain %}{{ bookstack.domain }}{% else %}{{ bookstack.subdomain + "." + domain }}{% endif %}/) or [http://{% if bookstack.domain %}{{ bookstack.domain }}{% else %}{{ bookstack.subdomain + "." + domain }}{% endif %}/](http://{% if bookstack.domain %}{{ bookstack.domain }}{% else %}{{ bookstack.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ bookstack.subdomain + "." + tor_domain }}/](http://{{ bookstack.subdomain + "." + tor_domain }}/)
{% endif %}
