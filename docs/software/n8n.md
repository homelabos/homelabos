# n8n

[n8n](https://n8n.io) n8n is a free and open node based Workflow Automation Tool.

## Access

It is available at [https://{% if n8n.domain %}{{ n8n.domain }}{% else %}{{ n8n.subdomain + "." + domain }}{% endif %}/](https://{% if n8n.domain %}{{ n8n.domain }}{% else %}{{ n8n.subdomain + "." + domain }}{% endif %}/) or [http://{% if n8n.domain %}{{ n8n.domain }}{% else %}{{ n8n.subdomain + "." + domain }}{% endif %}/](http://{% if n8n.domain %}{{ n8n.domain }}{% else %}{{ n8n.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ n8n.subdomain + "." + tor_domain }}/](http://{{ n8n.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
n8n:
  https_only: True
  auth: True
```
