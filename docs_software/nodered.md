# NodeRED

[NodeRED](https://nodered.org/) Node-RED is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.

## Access

It is available at [https://{% if nodered.domain %}{{ nodered.domain }}{% else %}{{ nodered.subdomain + "." + domain }}{% endif %}/](https://{% if nodered.domain %}{{ nodered.domain }}{% else %}{{ nodered.subdomain + "." + domain }}{% endif %}/) or [http://{% if nodered.domain %}{{ nodered.domain }}{% else %}{{ nodered.subdomain + "." + domain }}{% endif %}/](http://{% if nodered.domain %}{{ nodered.domain }}{% else %}{{ nodered.subdomain + "." + domain }}{% endif %}/)

{% if enable_tor %}
It is also available via Tor at [http://{{ nodered.subdomain + "." + tor_domain }}/](http://{{ nodered.subdomain + "." + tor_domain }}/)
{% endif %}

## Security enable/disable https_only and auth

To enable https_only or auth set the service config to True
`settings/config.yml`

```
nodered:
  https_only: True
  auth: True
```
