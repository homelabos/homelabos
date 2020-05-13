# Portainer

[Portainer](https://www.portainer.io/) is a Docker management interface, for the more advanced user.

## Access

It is available at [https://{% if portainer.domain %}{{ portainer.domain }}{% else %}{{ portainer.subdomain + "." + domain }}{% endif %}/](https://{% if portainer.domain %}{{ portainer.domain }}{% else %}{{ portainer.subdomain + "." + domain }}{% endif %}/) or [http://{% if portainer.domain %}{{ portainer.domain }}{% else %}{{ portainer.subdomain + "." + domain }}{% endif %}/](http://{% if portainer.domain %}{{ portainer.domain }}{% else %}{{ portainer.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ portainer.subdomain + "." + tor_domain }}/](http://{{ portainer.subdomain + "." + tor_domain }}/)
{% endif %}
