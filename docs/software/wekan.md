# Wekan

[Wekan](https://wekan.github.io/) Open source Kanban board with MIT license

## Access

It is available at [https://{% if wekan.domain %}{{ wekan.domain }}{% else %}{{ wekan.subdomain + "." + domain }}{% endif %}/](https://{% if wekan.domain %}{{ wekan.domain }}{% else %}{{ wekan.subdomain + "." + domain }}{% endif %}/) or [http://{% if wekan.domain %}{{ wekan.domain }}{% else %}{{ wekan.subdomain + "." + domain }}{% endif %}/](http://{% if wekan.domain %}{{ wekan.domain }}{% else %}{{ wekan.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ wekan.subdomain + "." + tor_domain }}/](http://{{ wekan.subdomain + "." + tor_domain }}/)
{% endif %}