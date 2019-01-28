# Portainer

[Portainer](https://www.portainer.io/) is a Docker management interface, for the more advanced user.

## Access

It is available at [https://docker.{{ domain }}/](https://docker.{{ domain }}/) or [http://docker.{{ domain }}/](http://docker.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://docker.{{ tor_domain }}/](http://docker.{{ tor_domain }}/)
{% endif %}
