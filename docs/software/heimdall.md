# Heimdall

[Heimdall](https://heimdall.site/) Heimdall Application Dashboard is a dashboard for all your web applications.

## Access

It is available at [https://{% if heimdall.domain %}{{ heimdall.domain }}{% else %}{{ heimdall.subdomain + "." + domain }}{% endif %}/](https://{% if heimdall.domain %}{{ heimdall.domain }}{% else %}{{ heimdall.subdomain + "." + domain }}{% endif %}/) or [http://{% if heimdall.domain %}{{ heimdall.domain }}{% else %}{{ heimdall.subdomain + "." + domain }}{% endif %}/](http://{% if heimdall.domain %}{{ heimdall.domain }}{% else %}{{ heimdall.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ heimdall.subdomain + "." + tor_domain }}/](http://{{ heimdall.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
heimdall:
  https_only: True
  auth: True
```
