# n8n

[n8n](https://n8n.io) n8n is a free and open node based Workflow Automation Tool.

## Access

It is available at [https://n8n.{{ domain }}/](https://n8n.{{ domain }}/) or [http://n8n.{{ domain }}/](http://n8n.{{ domain }}/)

{% if enable_tor %}
It is also available via Tor at [http://n8n.{{ tor_domain }}/](http://n8n.{{ tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

n8n:
  https_only: True
  auth: True