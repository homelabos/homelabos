# Huginn

[Huginn](https://github.com/huginn/huginn) Create agents that monitor and act on your behalf. Your agents are standing by!

## Access

It is available at [https://{% if huginn.domain %}{{ huginn.domain }}{% else %}{{ huginn.subdomain + "." + domain }}{% endif %}/](https://{% if huginn.domain %}{{ huginn.domain }}{% else %}{{ huginn.subdomain + "." + domain }}{% endif %}/) or [http://{% if huginn.domain %}{{ huginn.domain }}{% else %}{{ huginn.subdomain + "." + domain }}{% endif %}/](http://{% if huginn.domain %}{{ huginn.domain }}{% else %}{{ huginn.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ huginn.subdomain + "." + tor_domain }}/](http://{{ huginn.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
huginn:
  https_only: True
  auth: True
```