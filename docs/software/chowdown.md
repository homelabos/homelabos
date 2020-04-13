# Chowdown

[Chowdown](https://hub.docker.com/r/gregyankovoy/chowdown)  Simple recipes in Markdown format

## Access

It is available at [https://chowdown.{{ domain }}/](https://chowdown.{{ domain }}/) or [http://chowdown.{{ domain }}/](http://chowdown.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://chowdown.{{ tor_domain }}/](http://chowdown.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

chowdown:
  https_only: True
  auth: True