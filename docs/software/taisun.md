# Taisun

[Taisun](https://www.taisun.io/) Single Server Docker Management for Humans

## Access

It is available at [https://{% if taisun.domain %}{{ taisun.domain }}{% else %}{{ taisun.subdomain + "." + domain }}{% endif %}/](https://{% if taisun.domain %}{{ taisun.domain }}{% else %}{{ taisun.subdomain + "." + domain }}{% endif %}/) or [http://{% if taisun.domain %}{{ taisun.domain }}{% else %}{{ taisun.subdomain + "." + domain }}{% endif %}/](http://{% if taisun.domain %}{{ taisun.domain }}{% else %}{{ taisun.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ taisun + "." + tor_domain }}/](http://{{ taisun + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
taisun:
  https_only: True
  auth: True
```
