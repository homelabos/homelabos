# Chowdown

[Chowdown](https://hub.docker.com/r/gregyankovoy/chowdown)  Simple recipes in Markdown format

## Access

It is available at [https://{% if chowdown.domain %}{{ chowdown.domain }}{% else %}{{ chowdown.subdomain + "." + domain }}{% endif %}/](https://{% if chowdown.domain %}{{ chowdown.domain }}{% else %}{{ chowdown.subdomain + "." + domain }}{% endif %}/) or [http://{% if chowdown.domain %}{{ chowdown.domain }}{% else %}{{ chowdown.subdomain + "." + domain }}{% endif %}/](http://{% if chowdown.domain %}{{ chowdown.domain }}{% else %}{{ chowdown.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ chowdown.subdomain + "." + tor_domain }}/](http://{{ chowdown.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
chowdown:
  https_only: True
  auth: True
```