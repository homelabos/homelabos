# Gotify

[Gotify](https://github.com/gotify/server) A simple server for sending and receiving messages in real-time per WebSocket. (Includes a sleek web-ui)

## Access

It is available at [https://{% if gotify.domain %}{{ gotify.domain }}{% else %}{{ gotify.subdomain + "." + domain }}{% endif %}/](https://{% if gotify.domain %}{{ gotify.domain }}{% else %}{{ gotify.subdomain + "." + domain }}{% endif %}/) or [http://{% if gotify.domain %}{{ gotify.domain }}{% else %}{{ gotify.subdomain + "." + domain }}{% endif %}/](http://{% if gotify.domain %}{{ gotify.domain }}{% else %}{{ gotify.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ gotify.subdomain + "." + tor_domain }}/](http://{{ gotify.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
gotify:
  https_only: True
  auth: True
```
