# Teedy

[Teedy](https://teedy.io) Document Management made simple for everyone

## Access

It is available at [https://{% if teedy.domain %}{{ teedy.domain }}{% else %}{{ teedy.subdomain + "." + domain }}{% endif %}/](https://{% if teedy.domain %}{{ teedy.domain }}{% else %}{{ teedy.subdomain + "." + domain }}{% endif %}/) or [http://{% if teedy.domain %}{{ teedy.domain }}{% else %}{{ teedy.subdomain + "." + domain }}{% endif %}/](http://{% if teedy.domain %}{{ teedy.domain }}{% else %}{{ teedy.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ teedy + "." + tor_domain }}/](http://{{ teedy + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
teedy:
  https_only: True
  auth: True
```
