# Mealie

[Mealie](https://hay-kot.github.io/mealie/)  Simple recipes in Markdown format

The docker image comes from [hkotel/mealie:latest](https://hub.docker.com/r/hkotel/mealie)

## Access

It is available at [https://{% if mealie.domain %}{{ mealie.domain }}{% else %}{{ mealie.subdomain + "." + domain }}{% endif %}/](https://{% if mealie.domain %}{{ mealie.domain }}{% else %}{{ mealie.subdomain + "." + domain }}{% endif %}/) or [http://{% if mealie.domain %}{{ mealie.domain }}{% else %}{{ mealie.subdomain + "." + domain }}{% endif %}/](http://{% if mealie.domain %}{{ mealie.domain }}{% else %}{{ mealie.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ mealie.subdomain + "." + tor_domain }}/](http://{{ mealie.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
mealie:
  https_only: True
  auth: True
```
