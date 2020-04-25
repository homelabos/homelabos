# Heimdall

[Heimdall](https://heimdall.site/) Heimdall Application Dashboard is a dashboard for all your web applications.

## Access

It is available at [https://heimdall.{{ domain }}/](https://heimdall.{{ domain }}/) or [http://heimdall.{{ domain }}/](http://heimdall.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://heimdall.{{ tor_domain }}/](http://heimdall.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
heimdall:
  https_only: True
  auth: True
```