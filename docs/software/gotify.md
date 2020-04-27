# Gotify

[Gotify](https://github.com/gotify/server) A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)

## Access

It is available at [https://gotify.{{ domain }}/](https://gotify.{{ domain }}/) or [http://gotify.{{ domain }}/](http://gotify.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://gotify.{{ tor_domain }}/](http://gotify.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

gotify:
  https_only: True
  auth: True